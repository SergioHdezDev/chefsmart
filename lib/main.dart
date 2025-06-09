import 'package:chefsmart/screens/login_screen.dart';
import 'package:chefsmart/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<FirebaseApp> _initFirebase() async {
    // Inicializa Firebase solo si la plataforma es soportada
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loader mientras inicializa Firebase
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Muestra error si falla la inicialización
            return Scaffold(
              body: Center(
                child: Text(
                  'Error al inicializar Firebase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            // Si todo va bien, muestra la pantalla de login
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        // ... otras rutas si tienes
      },
    );
  }
}