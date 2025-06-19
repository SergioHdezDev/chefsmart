import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usa el mismo color que el botón de login
    final Color loginButtonColor = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Registro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ingresa tu nombre',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      style: const TextStyle(fontSize: 16),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Ingresa tu email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        // Validación básica de email
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Crea Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      style: const TextStyle(fontSize: 16),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirma Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      style: const TextStyle(fontSize: 16),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: loginButtonColor,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // 1. Crear usuario en Firebase Auth
                              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                              if (!mounted) return;

                              // 2. Guardar datos en Firestore
                              await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
                                'name': _nameController.text.trim(),
                                'email': _emailController.text.trim(),
                              });
                              if (!mounted) return;

                              // Mostrar mensaje de éxito
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await Future.delayed(const Duration(seconds: 1));
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                this.context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al registrar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Registrarme'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}