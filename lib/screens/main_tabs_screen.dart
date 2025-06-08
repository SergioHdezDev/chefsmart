import 'package:chefsmart/screens/recetas_screen.dart';
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
    Center(child: Text('Búsqueda')),
    VideoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex < 4 ? _screens[_currentIndex] : _screens[0],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 4) {
            await FirebaseAuth.instance.signOut();
            // No pongas ningún otro código aquí
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Búsqueda'),
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
