import 'package:flutter/material.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:chefsmart/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/fondo_login.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset("assets/images/logo_app.png"),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "email",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password),
                                  hintText: "Password",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                      AppColors.primary,
                                    ),
                                  ),
                                  child: Text(
                                    "Iniciar sesión",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("No tengo una cuenta, "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Registrarme",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}