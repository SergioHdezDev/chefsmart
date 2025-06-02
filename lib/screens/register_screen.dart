import 'package:flutter/material.dart';
import 'package:chefsmart/core/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // <-- Fondo blanco
        elevation: 0, // Opcional: quita la sombra
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.black, // <-- Texto negro
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Registro',
              style: const TextStyle(
                color: Colors.black, // <-- Texto negro
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "Ingresa tu nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Ingresa tu email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Crea Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Confirmar contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Acción de registro
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                ),
                child: const Text(
                  "Registrarme",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}