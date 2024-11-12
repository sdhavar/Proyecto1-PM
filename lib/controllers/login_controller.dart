import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Load all user credentials from SharedPreferences
  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');

    if (usersJson != null) {
      List<dynamic> usersList = jsonDecode(usersJson);
      for (var user in usersList) {
        String email = user['email'];
        String password = user['password'];
        
        // Optionally preload the first set of credentials
        if (emailController.text.isEmpty) {
          emailController.text = email;
          passwordController.text = password;
        }
      }
    }
  }

  // Save a new user credential
  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');
    List<Map<String, String>> usersList = [];

    if (usersJson != null) {
      usersList = List<Map<String, String>>.from(jsonDecode(usersJson));
    }

    // Check if the user already exists and either update or add new credentials
    bool userExists = false;
    for (var user in usersList) {
      if (user['email'] == email) {
        user['password'] = password; // Update password for existing user
        userExists = true;
        break;
      }
    }
    if (!userExists) {
      usersList.add({'email': email, 'password': password}); // Add new user
    }

    // Save the updated list back to SharedPreferences
    await prefs.setString('users', jsonEncode(usersList));
  }

  // Validate login credentials for all stored users
  Future<bool> validateLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');

    if (usersJson == null) {
      return false; // No users stored
    }

    List<dynamic> usersList = jsonDecode(usersJson);
    for (var user in usersList) {
      if (user['email'] == email && user['password'] == password) {
        return true; // Credentials are valid
      }
    }
    return false; // Invalid credentials
  }

  // Clear the controllers
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // Method to log out (optionally clear specific user)
  Future<void> logout() async {
    // Implementation of logout can be done based on your needs
    clearControllers(); // Clear the controllers
  }

  // Dispose of the controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
