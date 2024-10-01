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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título con el nombre del usuario
                  Text(
                    'Hola, $username',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto', // Cambié la tipografía
                    ),
                  ),
                  SizedBox(height: 20),
                  // Párrafo explicativo
                  Text(
                    'Aquí puedes llevar un control diario de tus consumos y ganar recompensas por tus hábitos saludables.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  // Botón para ir a la página de gamificación
                  CustomButton(
                    text: 'Gamification',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GamificationPage()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Botón para ir a la encuesta diaria de consumo
                  CustomButton(
                    text: 'Encuesta Diaria',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SurveyPage()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Botón para el registro de datos de consumo diario
                  CustomButton(
                    text: 'Registro Diario',
                    onPressed: () {
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
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF034f84), // Color de fondo renovado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bordes más redondeados
        ),
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14), // Aumenté el padding
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18), // Cambié tamaño de fuente
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
