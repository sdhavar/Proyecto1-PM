import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart'; // Importar el controlador

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Instancia del controlador de registro
  final SignupController _signupController = SignupController();

  @override
  void dispose() {
    _signupController.dispose(); // Liberar recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            color: Color(0xFF4ba3c7),
            height: double.infinity,
            width: double.infinity,
          ),
          // Círculos decorativos
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
          // Botón de Login
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
          // Formulario de Registro
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
                      controller: _signupController.usernameController, // Usar el controlador
                      validator: _signupController.validateUsername,
                    ),
                    FormInput(
                      icon: Icons.lock,
                      hint: 'PASSWORD',
                      obscureText: true,
                      controller: _signupController.passwordController, // Usar el controlador
                      validator: _signupController.validatePassword,
                    ),
                    FormInput(
                      icon: Icons.email,
                      hint: 'EMAIL ADDRESS',
                      controller: _signupController.emailController, // Usar el controlador
                      validator: _signupController.validateEmail,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Verificar si el correo ya está registrado
                            bool emailExists = await _signupController.checkIfEmailExists(_signupController.emailController.text);
                            if (emailExists) {
                              throw Exception('Este correo ya está registrado. Por favor, elige otro.');
                            }

                            // Guardar credenciales
                            await _signupController.registerUser();

                            // Navegar a MainPage pasando el nombre de usuario registrado
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                    username: _signupController
                                        .usernameController.text),
                              ),
                            );
                          } catch (e) {
                            // Mostrar mensaje de error si el correo ya está registrado
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
