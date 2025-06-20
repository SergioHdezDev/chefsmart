import 'package:chefsmart/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chefsmart/data/models/receta_detail_response.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecetaDetalleScreen extends StatefulWidget {
  final RecetaDetailResponse receta;

  const RecetaDetalleScreen({super.key, required this.receta});

  @override
  State<RecetaDetalleScreen> createState() => _RecetaDetalleScreenState();
}

class _RecetaDetalleScreenState extends State<RecetaDetalleScreen> {
  YoutubePlayerController? _videoController;
  bool _favoritoCambio = false; // Agrega esto en tu State

  @override
  void initState() {
    super.initState();
    final videoUrl = widget.receta.video.trim();
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    print('VIDEO URL: "$videoUrl"');
    print('VIDEO ID: $videoId');
    if (videoId != null && videoId.isNotEmpty) {
      _videoController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.close();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) return const SizedBox();
    // Usa una Key única basada en el videoId para forzar la reconstrucción
    final videoId = YoutubePlayerController.convertUrlToId(widget.receta.video.trim());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: YoutubePlayer(
              key: ValueKey(videoId), // <--- ESTA LÍNEA ES LA CLAVE
              controller: _videoController!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecetaDetalle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receta: ${widget.receta.titulo}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            "Regiones: ${widget.receta.region is List ? (widget.receta.region as List).join(', ') : widget.receta.region}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes:",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          ...widget.receta.ingredientes.map((ing) => Text("- $ing")),
        ],
      ),
    );
  }

  Future<bool> _isFavorito(String recetaId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final snapshot = await FirebaseFirestore.instance
        .collection('favorito')
        .where('idusuario', isEqualTo: user.uid)
        .where('idreceta', isEqualTo: FirebaseFirestore.instance.doc('recetas/$recetaId'))
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> _agregarFavorito(String recetaId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('favorito').add({
      'idusuario': user.uid,
      'idreceta': FirebaseFirestore.instance.doc('recetas/$recetaId'),
      'fecha': DateTime.now(),
    });
    _favoritoCambio = true;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta agregada a favoritos')),
      );
    }
  }

  Future<void> _eliminarFavorito(String recetaId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('favorito')
        .where('idusuario', isEqualTo: user.uid)
        .where('idreceta', isEqualTo: FirebaseFirestore.instance.doc('recetas/$recetaId'))
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _favoritoCambio = true;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta eliminada de favoritos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta.titulo),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _favoritoCambio);
          },
        ),
        actions: [
          FutureBuilder<bool>(
            future: _isFavorito(widget.receta.id),
            builder: (context, snapshot) {
              final isFav = snapshot.data ?? false;
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: () async {
                      if (isFav) {
                        await _eliminarFavorito(widget.receta.id);
                        setState(() {});
                      } else {
                        await _agregarFavorito(widget.receta.id);
                        setState(() {});
                      }
                    },
                    tooltip: isFav ? 'Quitar de favoritos' : 'Agregar a favoritos',
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Text('Favorito', style: TextStyle(color:AppColors.primary)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildVideoPlayer(),
            const SizedBox(height: 16),
            _buildRecetaDetalle(),
          ],
        ),
      ),
    );
  }
}