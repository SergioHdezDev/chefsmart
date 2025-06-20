import 'package:chefsmart/core/app_colors.dart';
import 'package:chefsmart/data/models/rectas_response.dart';
import 'package:chefsmart/screens/receta_detalle_screen.dart';
import 'package:chefsmart/youtube_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:chefsmart/data/recetas_repository.dart';
import 'package:chefsmart/data/models/receta_detail_response.dart';

class RecetasScreen extends StatelessWidget {
  const RecetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<List<RecetasResponse>>(
            future: Future.wait([
              RecetasRepository().fetchRecetasPopulares(),
              RecetasRepository().fetchRecetasNuevas(),
              RecetasRepository().fetchRecetasFavoritas(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final recetasPopulares = snapshot.data?[0].recetas ?? [];
              final nuevas = snapshot.data?[1].recetas ?? [];
              final favoritas = snapshot.data?[2].recetas ?? [];

              return ListView(
                children: [
                  
                  const SizedBox(height: 32),
                  // Recetas Populares
                  const Text(
                    'Recetas Populares',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recetasPopulares.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final receta = recetasPopulares[index];
                        return _popularRecipeCard(context, receta);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Nuevas Recetas
                  const Text(
                    'Nuevas Recetas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...nuevas.map((receta) => _newRecipeTile(context, receta)),
                  const SizedBox(height: 32),
                  const Text(
                    'Recetas Favoritas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...favoritas.map((receta) => _newRecipeTile(context, receta)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Botón de región
  static Widget _regionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.accent),
      ),
    );
  }

  // Card de receta popular
  static Widget _popularRecipeCard(BuildContext context, RecetaDetailResponse receta) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecetaDetalleScreen(receta: receta),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(YouTubeThumbnail.getThumbnail(receta.video), height: 100, width: 160, fit: BoxFit.cover)
            ),
            const SizedBox(height: 8),
            Text(receta.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              receta.region is List ? (receta.region as List).join(', ') : receta.region,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Tile de nueva receta
  static Widget _newRecipeTile(BuildContext context, RecetaDetailResponse receta) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: ListTile(
          leading: Image.network(
            YouTubeThumbnail.getThumbnail(receta.video),
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
          title: Text(receta.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            receta.region,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecetaDetalleScreen(receta: receta),
              ),
            );
          },
        ),
      ),
    );
  }
}