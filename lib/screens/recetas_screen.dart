import 'package:chefsmart/core/app_colors.dart';
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
          child: FutureBuilder(
            future: RecetasRepository().fetchRecetas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final recetas = snapshot.data?.recetas ?? [];

              // Filtra populares y nuevas
              final populares = recetas.where((r) => r.populares == true).toList();
              final nuevas = recetas.where((r) => r.nuevo == true).toList();

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
                      itemCount: populares.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final receta = populares[index];
                        return _popularRecipeCard(
                          receta.nombre,
                          receta.region,
                          receta.imagenes,
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
                        receta.nombre,
                        receta.region,
                        receta.imagenes,
                      )),
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
  static Widget _popularRecipeCard(String title, List<String> regiones, List<String> imagenes) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imagenes.isNotEmpty
                ? Image.network(imagenes.first.trim(), height: 100, width: 160, fit: BoxFit.cover)
                : Container(
                    height: 100,
                    width: 160,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            regiones.join(', '),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Tile de nueva receta
  static Widget _newRecipeTile(String title, List<String> regiones, List<String> imagenes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagenes.isNotEmpty
                ? Image.network(imagenes.first.trim(), height: 48, width: 48, fit: BoxFit.cover)
                : Container(
                    height: 48,
                    width: 48,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                regiones.join(', '),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}