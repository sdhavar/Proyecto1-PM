import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart';
import 'daily_intake_page.dart';

class MainPage extends StatelessWidget {
  final String username;

  MainPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF92a8d1), Color(0xFFf7cac9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          // Círculos decorativos
          Positioned(
            top: 30,
            left: 50,
            child: Circle(
              diameter: 100,
              color: Color(0xFF034f84),
            ),
          ),
          Positioned(
            top: 150,
            right: 30,
            child: Circle(
              diameter: 120,
              color: Color(0xFFf7786b),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: Circle(
              diameter: 180,
              color: Color(0xFF92a8d1),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 80,
            child: Circle(
              diameter: 100,
              color: Color(0xFFf7cac9),
            ),
          ),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Encabezado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, $username',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Aquí puedes llevar un control diario de tus consumos y ganar recompensas por tus hábitos saludables.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF034f84),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80), // Aumentar el espacio para bajar los contenedores
                  // Contenedores centrados
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomContainer(
                              text: 'Gamificación',
                              icon: Icons.star,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GamificationPage()),
                                );
                              },
                            ),
                            CustomContainer(
                              text: 'Encuesta Diaria',
                              icon: Icons.poll,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SurveyPage()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        CustomContainer(
                          text: 'Registro Diario',
                          icon: Icons.book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DailyIntakePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Barra inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.home, color: Colors.grey[700]),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.settings, color: Colors.grey[700]),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
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
    );
  }
}

// Widget personalizado para los contenedores
class CustomContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  CustomContainer({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Ancho fijo para todos los contenedores
        height: 150, // Alto fijo para todos los contenedores
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFF034f84), // Color del contenedor
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 48),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Cambié el tamaño de la fuente
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Círculos decorativos (ya estaban en el código)
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
