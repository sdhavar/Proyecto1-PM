import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Validación de correo con dominios permitidos
  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final allowedDomains = [
      'gmail.com',
      'hotmail.com',
      'outlook.com',
      'yahoo.com'
    ];

    if (value == null || value.isEmpty) {
      return "Enter email address";
    } else if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    } else {
      final domain = value.split('@').last;
      if (!allowedDomains.contains(domain)) {
        return "Email must be from gmail, hotmail, outlook, or yahoo";
      }
    }
    return null;
  }

  // Validación de username y contraseña (mínimo 6 caracteres)
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter username";
    } else if (value.length < 6) {
      return "Username must be at least 6 characters";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Guardar credenciales en SharedPreferences
  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
  }

  // Método para liberar los controladores
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
}
