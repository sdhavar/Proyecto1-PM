import 'package:flutter/material.dart';
import 'main_page.dart';
import 'signup_page.dart';
import 'package:flutter_application_1/controllers/login_controller.dart'; // Importar el controlador

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  // Instancia del controlador de login
  final LoginController _loginController = LoginController();

  @override
  void initState() {
    super.initState();
    _loginController.loadCredentials(); // Cargar credenciales guardadas
  }

  @override
  void dispose() {
    _loginController.dispose(); // Liberar los recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo
        Container(
          color: Color(0xFF4ba3c7),
          height: double.infinity,
          width: double.infinity,
        ),
        // Círculos decorativos
        Positioned(
          top: 50,
          left: 20,
          child: Circle(
            diameter: 150,
            color: Color(0xFF003f7f),
          ),
        ),
        Positioned(
          top: 100,
          left: 50,
          child: Circle(
            diameter: 100,
            color: Color(0xFF0056b3),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: Circle(
            diameter: 150,
            color: Color(0xFF003f7f),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 50,
          child: Circle(
            diameter: 100,
            color: Color(0xFF0056b3),
          ),
        ),
        // Nombre de la app
        Positioned(
          top: 40,
          left: 20,
          child: Text(
            'Mi Mejor Ser',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Contenido del login
        Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                LoginInput(
                  icon: Icons.person,
                  hint: 'USERNAME',
                  controller: _loginController.usernameController, // Usar el controlador
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter username";
                    } else if (value.length < 6) {
                      return "Username must have at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                LoginInput(
                  icon: Icons.lock,
                  hint: 'PASSWORD',
                  obscureText: true,
                  controller: _loginController.passwordController, // Usar el controlador
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter password";
                    } else if (value.length < 6) {
                      return "Password must have at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          String username = _loginController.usernameController.text;
                          String password = _loginController.passwordController.text;

                          // Validar las credenciales con el controlador
                          bool isValid = await _loginController.validateLogin(username, password);

                          if (isValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainPage(username: username)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid username or password"),
                                backgroundColor: Colors.red,
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
                          color: Color(0xFF2c2c54),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c54),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoginInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  LoginInput({
    required this.icon,
    required this.hint,
    this.obscureText = false,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey),
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
