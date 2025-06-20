import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chefsmart/screens/login_screen.dart';
import 'package:chefsmart/screens/home_screen.dart';
import 'package:chefsmart/firestore_service.dart'; // ✅ Importamos FirestoreService


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializa Firebase antes de ejecutar otras funciones
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Actualizar enlaces de video antes de iniciar la app
  await FirestoreService().actualizarVideos();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<FirebaseApp> _initFirebase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Oculta el banner de depuración
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), // ✅ Personaliza el tema de la app
      home: FutureBuilder(
        future: _initFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ), // ✅ Loader mientras inicializa Firebase
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Error al inicializar Firebase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ), // ✅ Muestra error si falla la inicialización
                ),
              ),
            );
          } else {
            return const LoginScreen(); // ✅ Muestra la pantalla de login al iniciar
          }
        },
      ),
      routes: {'/home': (context) => const HomeScreen()},
    );
  }
}
