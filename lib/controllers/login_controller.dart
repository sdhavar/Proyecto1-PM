import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Cargar credenciales desde SharedPreferences
  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    if (username != null && password != null) {
      usernameController.text = username;
      passwordController.text = password;
    }
  }

  // Guardar credenciales en SharedPreferences
  Future<void> saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  // Validar credenciales de inicio de sesión
  Future<bool> validateLogin(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (storedUsername == null || storedPassword == null) {
      return false; // No se encontraron credenciales almacenadas
    }

    return username == storedUsername && password == storedPassword;
  }

  // Limpiar los controladores
  void clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }

  // Dispose de los controladores
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
