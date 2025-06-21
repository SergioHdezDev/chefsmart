import 'package:chefsmart/screens/recetas_screen.dart';
import 'package:chefsmart/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chefsmart/screens/login_screen.dart';
import 'package:chefsmart/screens/video_screen.dart';
import 'package:chefsmart/screens/home_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  void _goToRecetasTab() {
    setState(() {
      _currentIndex = 1; // Índice de Recetas
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onRegionTap: _goToRecetasTab), // Pasa el callback aquí
      const RecetasScreen(),
      const SearchScreen(),
      const VideoScreen(url: ''),
      const Center(child: Text('Presiona para salir')),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            _logout();
          } else {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Videos'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}