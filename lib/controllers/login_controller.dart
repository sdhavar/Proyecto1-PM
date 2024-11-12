import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Cargar credenciales desde SharedPreferences
  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      emailController.text = email;
      passwordController.text = password;
    }
  }

  // Guardar credenciales en SharedPreferences
  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  // Validar credenciales de inicio de sesión
  Future<bool> validateLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail == null || storedPassword == null) {
      return false; // No se encontraron credenciales almacenadas
    }

    return email == storedEmail && password == storedPassword;
  }

  // Limpiar los controladores
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // Dispose de los controladores
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
