import 'package:flutter/material.dart';

// Asegúrate de tener estas imágenes en tu carpeta assets/images/
// 'assets/images/fondo_home.jpg'
// 'assets/images/caribe.jpg'
// 'assets/images/andina.jpg'
// ... y las demás imágenes de categorías

class HomeScreen extends StatelessWidget {
  final VoidCallback? onRegionTap;
  const HomeScreen({super.key, this.onRegionTap});

  // Define las categorías fuera del builder
  static final List<Map<String, String>> categories = [
    {'name': 'Caribe', 'image': 'assets/images/caribe.jpg'},
    {'name': 'Andina', 'image': 'assets/images/andina.jpg'},
    {'name': 'Pacífica', 'image': 'assets/images/pacifica.jpg'},
    {'name': 'Insular', 'image': 'assets/images/insular.jpg'},
    {'name': 'Orinoquia', 'image': 'assets/images/orinoquia.jpg'},
    {'name': 'Amazonia', 'image': 'assets/images/amazonia.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double topSafeAreaHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección superior con la imagen de fondo y el Card de bienvenida
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Imagen de fondo
                SizedBox(
                  height: screenSize.height * 0.45,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/fondo_home.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                              Text(
                                'Error fondo_home.jpg',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradiente oscuro
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3), // 30% opacidad arriba
                          Colors.black.withOpacity(0.0), // 0% opacidad abajo
                        ],
                      ),
                    ),
                  ),
                ),
                // Card de Bienvenida
                Positioned(
                  top: topSafeAreaHeight + appBarHeight + 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'BIENVENIDOS a',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Recetas\nColombianas',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE48E0D),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Explora deliciosas recetas de todas las regiones de Colombia',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Espacio después de la Card de bienvenida
            SizedBox(height: 50),

            // Sección "Descubre" y categorías (fondo blanco)
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Descubre',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Cuadrícula de categorías
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        name: category['name']!,
                        imagePath: category['image']!,
                        onTap: onRegionTap ?? () {}, // Solución aquí
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para las tarjetas de categoría - ¡MODIFICADO CON HOVER EFFECT!
class CategoryCard extends StatefulWidget {
  final String name;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isHovering =
      false; // Estado para controlar si el cursor está sobre la tarjeta

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Detecta la entrada y salida del cursor
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: GestureDetector(
        // Detecta el clic (tap)
        onTap: widget.onTap ?? () {}, // Llama solo si no es nulo
        child: AnimatedScale(
          // Anima la escala de la tarjeta
          scale:
              _isHovering
                  ? 1.05
                  : 1.0, // Escala a 1.05 si está en hover, sino 1.0
          duration: const Duration(
            milliseconds: 200,
          ), // Duración de la animación
          curve: Curves.easeOut, // Curva de la animación
          child: Card(
            elevation: _isHovering ? 8 : 4, // Aumenta la sombra al hacer hover
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    widget.imagePath, // Usa widget.imagePath
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Text(
                                'Error: ${widget.name}', // Usa widget.name
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    widget.name, // Usa widget.name
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
