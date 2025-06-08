import 'package:chefsmart/screens/recetas_screen.dart';
import 'package:chefsmart/screens/search_screen.dart'; // ✅ Importamos la pantalla de búsqueda
import 'package:flutter/material.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chefsmart/screens/login_screen.dart';
import 'video_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text('Home')),
    RecetasScreen(),
    SearchScreen(), // ✅ Ahora muestra la pantalla correcta
    VideoScreen(),
    Center(child: Text('Logout')),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      _logout();
    } else {
      setState(() => _currentIndex = index);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recetas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ), // ✅ Ajustado el nombre
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }
}
