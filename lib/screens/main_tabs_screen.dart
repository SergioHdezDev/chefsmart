import 'package:chefsmart/screens/recetas_screen.dart';
import 'package:chefsmart/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chefsmart/screens/login_screen.dart';
import 'package:chefsmart/screens/video_screen.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:chefsmart/screens/home_screen.dart'; // ¡¡¡IMPORTA TU HOMESCREEN AQUÍ!!!

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  // Lista de las pantallas que corresponden a cada pestaña del BottomNavigationBar
  final List<Widget> _screens = [
    const HomeScreen(), // ¡¡¡AHORA USA TU HOMESCREEN REAL!!!
    const RecetasScreen(),
    const SearchScreen(),
    const VideoScreen(),
    // Para la pestaña de Logout, no es una "pantalla" en sí,
    // sino una acción. Mantener un placeholder aquí es válido si la
    // acción de logout se maneja en _onItemTapped.
    const Center(child: Text('Presiona para salir')), // Esto solo se verá si la pestaña se activa sin salir
  ];

  void _onItemTapped(int index) {
    if (index == 4) { // El índice 4 corresponde a la pestaña 'Logout'
      _logout();
    } else {
      setState(() => _currentIndex = index);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    // pushAndRemoveUntil asegura que se eliminen todas las rutas anteriores
    // y la pila de navegación quede limpia, dejando solo LoginScreen.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Mantiene todos los ítems visibles y del mismo tamaño
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recetas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        selectedItemColor: AppColors.primary, // Color de ítem seleccionado (desde tu archivo AppColors)
        unselectedItemColor: Colors.grey, // Color de ítem no seleccionado
        showUnselectedLabels: true, // Asegura que las etiquetas de ítems no seleccionados se muestren
        elevation: 8, // Sombra en la barra de navegación inferior
      ),
    );
  }
}