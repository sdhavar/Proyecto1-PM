import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignupController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Validate email with allowed domains
  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final allowedDomains = ['gmail.com', 'hotmail.com', 'outlook.com', 'yahoo.com', 'uninorte.edu.co'];

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

  // Validate username (minimum 6 characters)
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter username";
    } else if (value.length < 6) {
      return "Username must be at least 6 characters";
    }
    return null;
  }

  // Validate password (minimum 6 characters)
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Check if the email already exists
  Future<bool> checkIfEmailExists(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');
    
    if (usersJson != null) {
      List<dynamic> usersList = jsonDecode(usersJson);
      for (var user in usersList) {
        if (user['email'] == email) {
          return true; // Email already registered
        }
      }
    }
    return false;
  }

  // Check if the username already exists
  Future<bool> checkIfUsernameExists(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');
    
    if (usersJson != null) {
      List<dynamic> usersList = jsonDecode(usersJson);
      for (var user in usersList) {
        if (user['username'] == username) {
          return true; // Username already registered
        }
      }
    }
    return false;
  }

  // Save user credentials in SharedPreferences
  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');
    List<Map<String, dynamic>> usersList = [];

    if (usersJson != null) {
      usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    }
    
    // Add the new user details
    usersList.add({
      'email': emailController.text,
      'username': usernameController.text,
      'password': passwordController.text,
    });

    // Save the updated list back to SharedPreferences
    await prefs.setString('users', jsonEncode(usersList));
  }

  // Dispose of the controllers
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
}
