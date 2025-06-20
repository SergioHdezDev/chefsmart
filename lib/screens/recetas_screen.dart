import 'package:chefsmart/core/app_colors.dart';
import 'package:chefsmart/data/models/rectas_response.dart';
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
               RecetasRepository().fetchRecetasNuevas()
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
              

              return ListView(
                children: [
                  // Título principal y regiones (igual que antes)
                  const Text(
                    'Regiones de Colombia',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Botones de regiones
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (var i = 0; i < 4; i += 2)
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: _regionButton(['Caribe', 'Pacífico', 'Andina', 'Orinoquía'][i]),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: _regionButton(['Caribe', 'Pacífico', 'Andina', 'Orinoquía'][i+1]),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
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
                        return _popularRecipeCard(
                          receta.titulo,
                          receta.region,
                          YouTubeThumbnail.getThumbnail(receta.video),
                        );
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
                  ...nuevas.map((receta) => _newRecipeTile(
                        receta.titulo,
                        receta.region,
                        YouTubeThumbnail.getThumbnail(receta.video))),
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
  static Widget _popularRecipeCard(String title, String region, String imagen) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imagen, height: 100, width: 160, fit: BoxFit.cover)
                
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            region,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Tile de nueva receta
  static Widget _newRecipeTile(String title, String region, String imagen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:  Image.network(imagen, height: 48, width: 48, fit: BoxFit.cover)
                
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                region,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}