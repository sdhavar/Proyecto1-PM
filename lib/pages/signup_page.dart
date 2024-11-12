import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart';
import 'package:flutter_application_1/controllers/firebase_controller.dart'; // Import the controller

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Instance of the Signup controller
  final SignupController _signupController = SignupController();

  @override
  void dispose() {
    _signupController.dispose(); // Release controller resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Container(
            color: Color(0xFF4ba3c7),
            height: double.infinity,
            width: double.infinity,
          ),
          // Decorative Circles
          Positioned(
            top: 10,
            left: 10,
            child: Circle(
              diameter: 200,
              color: Color(0xFF1A73E8),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: Circle(
              diameter: 150,
              color: Color(0xFF0D47A1),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 5,
            child: Circle(
              diameter: 200,
              color: Color(0xFF1A73E8),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 10,
            child: Circle(
              diameter: 150,
              color: Color(0xFF0D47A1),
            ),
          ),
          // Login Button
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Registration Form
          Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    FormInput(
                      icon: Icons.person,
                      hint: 'USERNAME',
                      controller: _signupController.usernameController, // Use the controller
                      validator: _signupController.validateUsername,
                    ),
                    FormInput(
                      icon: Icons.lock,
                      hint: 'PASSWORD',
                      obscureText: true,
                      controller: _signupController.passwordController, // Use the controller
                      validator: _signupController.validatePassword,
                    ),
                    FormInput(
                      icon: Icons.email,
                      hint: 'EMAIL ADDRESS',
                      controller: _signupController.emailController, // Use the controller
                      validator: _signupController.validateEmail,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Check if the email is already registered
                            bool emailExists = await _signupController.checkIfEmailExists(_signupController.emailController.text);
                            if (emailExists) {
                              throw Exception('Este correo ya está registrado. Por favor, elige otro.');
                            }

                            // Save credentials
                            await _signupController.registerUser();

                            // Extract username from email
                            String username = _signupController.extractUsername(_signupController.emailController.text);

                            // Navigate to MainPage passing the registered username
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(username: username),
                              ),
                            );
                          } catch (e) {
                            // Show error message if the email is already registered
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF0D47A1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  FormInput({
    required this.icon,
    required this.hint,
    this.obscureText = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFB0B0B0)),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Color(0xFFB0B0B0)),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final double diameter;
  final Color color;

  Circle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
