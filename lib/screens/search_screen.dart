// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _availableRecipes = [];
  List<String> _availableRegions = [];
  List<String> _availableIngredients = [];
  List<String> _selectedIngredients = [];
  String? _selectedRecipe;
  String? _selectedRegion;
  String? _selectedIngredient;
  List<Map<String, dynamic>> _recetasEncontradas = [];
  Map<String, dynamic>? _recetaSeleccionada;
  YoutubePlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadRecipes(), _loadRegions(), _loadIngredients()]);
  }

  Future<void> _loadRecipes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recetas').get();
    setState(() {
      _availableRecipes =
          snapshot.docs.map((doc) => doc['titulo'].toString()).toList();
    });
  }

  Future<void> _loadRegions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recetas').get();
    Set<String> regionSet = {};
    for (var doc in snapshot.docs) {
      var data = doc.data();
      if (data.containsKey("region") && data["region"] is String) {
        regionSet.add(data["region"]);
      }
    }
    setState(() {
      _availableRegions = regionSet.toList();
    });
  }

  Future<void> _loadIngredients() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recetas').get();
    Set<String> ingredientsSet = {};
    for (var doc in snapshot.docs) {
      if (doc["ingredientes"] is List) {
        ingredientsSet.addAll(List<String>.from(doc['ingredientes']));
      }
    }
    setState(() {
      _availableIngredients = ingredientsSet.toList();
    });
  }

  Future<void> _searchMatchingRecipes() async {
    if (_selectedIngredients.isEmpty) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('recetas')
            .where("ingredientes", arrayContainsAny: _selectedIngredients)
            .get();

    List<Map<String, dynamic>> resultados = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      List<String> ingredientes =
          data["ingredientes"] is List
              ? List<String>.from(data["ingredientes"])
              : [];

      resultados.add({
        "id": doc.id,
        "titulo": data["titulo"] ?? "Sin título",
        "video": data["video"] ?? "",
        "ingredientes": ingredientes,
        "faltantes":
            ingredientes
                .where((i) => !_selectedIngredients.contains(i))
                .toList(),
      });
    }

    setState(() {
      _recetasEncontradas = resultados;
      _recetaSeleccionada = null;
      _videoController?.close();
      _videoController = null;
    });
  }

  Future<void> _fetchRecipesByRegion(String region) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('recetas')
            .where("region", isEqualTo: region)
            .get();

    List<Map<String, dynamic>> resultados = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      List<String> ingredientes =
          data["ingredientes"] is List
              ? List<String>.from(data["ingredientes"])
              : [];

      resultados.add({
        "id": doc.id,
        "titulo": data["titulo"] ?? "Sin título",
        "video": data["video"] ?? "",
        "ingredientes": ingredientes,
        "faltantes":
            ingredientes
                .where((i) => !_selectedIngredients.contains(i))
                .toList(),
      });
    }

    setState(() {
      _recetasEncontradas = resultados;
      _recetaSeleccionada = null;
      _videoController?.close();
      _videoController = null;
    });
  }

  Future<void> _fetchRecipeDetails(String recipeTitle) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('recetas')
            .where("titulo", isEqualTo: recipeTitle)
            .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var data = doc.data();
      List<String> ingredientes =
          data["ingredientes"] is List
              ? List<String>.from(data["ingredientes"])
              : [];

      setState(() {
        _recetaSeleccionada = {
          "id": doc.id,
          "titulo": data["titulo"] ?? "Sin título",
          "video": data["video"] ?? "",
          "ingredientes": ingredientes,
          "faltantes":
              ingredientes
                  .where((i) => !_selectedIngredients.contains(i))
                  .toList(),
        };
        _recetasEncontradas = [];
        _initializeVideoPlayer(_recetaSeleccionada!["video"]);
      });
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    if (videoUrl.isEmpty) return;
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (videoId != null) {
      _videoController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
      setState(() {});
    }
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedItem,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedItem,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedIngredientsChips() {
    return Wrap(
      spacing: 8,
      children:
          _selectedIngredients
              .map(
                (ingredient) => Chip(
                  label: Text(ingredient),
                  onDeleted:
                      () => setState(
                        () => _selectedIngredients.remove(ingredient),
                      ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildRecetasEncontradas() {
    if (_recetasEncontradas.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recetas encontradas:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ..._recetasEncontradas.map(
          (receta) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            color: _recetaSeleccionada == receta ? Colors.amber.shade100 : null,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                receta['titulo'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  receta['faltantes'].isNotEmpty
                      ? Text("Faltantes: ${receta['faltantes'].join(', ')}")
                      : const Text("Todos los ingredientes disponibles"),
              onTap: () {
                setState(() {
                  _recetaSeleccionada = receta;
                  _initializeVideoPlayer(receta['video']);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) return const SizedBox();
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
            child: YoutubePlayer(controller: _videoController!),
          ),
        ),
      ),
    );
  }

  Widget _buildRecetaDetalle() {
    if (_recetaSeleccionada == null) return const SizedBox();
    final ingredientes = _recetaSeleccionada!['ingredientes'] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receta: ${_recetaSeleccionada!['titulo']}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes:",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          ...ingredientes.map<Widget>((ing) => Text("- $ing")),
        ],
      ),
    );
  }

  // Verifica si la receta ya es favorita
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

  // Agrega a favoritos
  Future<void> _agregarFavorito(String recetaId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('favorito').add({
      'idusuario': user.uid,
      'idreceta': FirebaseFirestore.instance.doc('recetas/$recetaId'),
      'fecha': DateTime.now(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta agregada a favoritos')),
      );
    }
  }

  // Elimina de favoritos
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta eliminada de favoritos')),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Recetas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child:
              _recetaSeleccionada == null
                  ? Column(
                    key: const ValueKey("filtros"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdown(
                        "Buscar por Receta",
                        _availableRecipes,
                        _selectedRecipe,
                        (value) {
                          setState(() {
                            _selectedRecipe = value;
                            _selectedRegion = null;
                            _selectedIngredient = null;
                            _selectedIngredients.clear();
                          });
                          _fetchRecipeDetails(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        "Buscar por Región",
                        _availableRegions,
                        _selectedRegion,
                        (value) {
                          setState(() => _selectedRegion = value);
                          _fetchRecipesByRegion(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        "Seleccionar Ingrediente",
                        _availableIngredients,
                        _selectedIngredient,
                        (value) {
                          if (value != null &&
                              !_selectedIngredients.contains(value)) {
                            setState(() {
                              _selectedIngredient = value;
                              _selectedIngredients.add(value);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildSelectedIngredientsChips(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _searchMatchingRecipes,
                        child: const Text("Buscar Recetas"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedRecipe = null;
                            _selectedRegion = null;
                            _selectedIngredient = null;
                            _selectedIngredients.clear();
                            _recetasEncontradas.clear();
                            _recetaSeleccionada = null;
                            _videoController?.close();
                            _videoController = null;
                          });
                        },
                        child: const Text("Resetear Búsqueda"),
                      ),
                      const SizedBox(height: 24),
                      _buildRecetasEncontradas(),
                    ],
                  )
                  : Column(
                    key: const ValueKey("detalle"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _recetaSeleccionada = null;
                                _videoController?.close();
                                _videoController = null;
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text("Volver"),
                          ),
                          const Spacer(),
                          FutureBuilder<bool>(
                            future: _isFavorito(_recetaSeleccionada!['id']),
                            builder: (context, snapshot) {
                              final isFav = snapshot.data ?? false;
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFav ? Icons.bookmark : Icons.bookmark_outline,
                                      color: isFav ? Colors.amber : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      if (isFav) {
                                        await _eliminarFavorito(_recetaSeleccionada!['id']);
                                        setState(() {});
                                      } else {
                                        await _agregarFavorito(_recetaSeleccionada!['id']);
                                        setState(() {});
                                      }
                                    },
                                    tooltip: isFav ? 'Quitar de favoritos' : 'Agregar a favoritos',
                                  ),
                                  const Text('Favorito'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildVideoPlayer(),
                      const SizedBox(height: 16),
                      _buildRecetaDetalle(),
                    ],
                  ),
        ),
      ),
    );
  }
}
