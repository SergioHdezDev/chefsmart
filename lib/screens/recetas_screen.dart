import 'package:chefsmart/core/app_colors.dart';
import 'package:flutter/material.dart';

class RecetasScreen extends StatelessWidget {
  const RecetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              // Título principal
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _popularRecipeCard('Arepas de Maíz', 'Caribe', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
                    const SizedBox(width: 16),
                    _popularRecipeCard('Sancocho de Pescado', 'Pacífico', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Nuevas Recetas
              const Text(
                'Nuevas Recetas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _newRecipeTile('Ajiaco Santafereño', 'Andina', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
              _newRecipeTile('Cazuela de Mariscos', 'Pacífico', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
              _newRecipeTile('Mote de Queso', 'Caribe', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
            ],
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
  static Widget _popularRecipeCard(String title, String region, String imageUrl) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, height: 100, width: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(region, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Tile de nueva receta
  static Widget _newRecipeTile(String title, String region, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, height: 48, width: 48, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(region, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}