import 'dart:ffi';

import 'package:chefsmart/core/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/fondo_login.png",
                          fit: BoxFit.cover,
                          height: 500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 400),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 255),
            child: Row(
              children: [
                Spacer(),
                Container(
                  width: 237,
                  height: 179,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_app.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 434,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
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
                                borderSide: BorderSide(color: Color.fromRGBO(0,0,0,0.2))
                              )
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
                                borderSide: BorderSide(color: Color.fromRGBO(0,0,0,0.2))
                              )
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
                                backgroundColor: WidgetStateProperty.all(AppColors.primary)
                              ),
                              child: Text("Iniciar sesión", style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center, 
                              children: [
                                Text("No tengo una cuenta, "),
                                Text(
                                  "Registrarme", 
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                          )
                          )
                          
                        ],
                      ),
                    ),
                  ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
