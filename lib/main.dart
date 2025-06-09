import 'package:chefsmart/screens/login_screen.dart';
import 'package:chefsmart/screens/home_screen.dart'; // Importa tu HomeScreen
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(), // Inicia siempre con LoginScreen
      routes: {
        '/home': (context) => const HomeScreen(), // Ruta para HomeScreen
        // ... otras rutas si tienes
      },
    );
  }
}