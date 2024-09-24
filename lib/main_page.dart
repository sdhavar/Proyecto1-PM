import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart'; // Página para la encuesta diaria de consumo
import 'daily_intake_page.dart'; // Página para el registro de datos de consumo diario

class MainPage extends StatelessWidget {
  final String username;

  MainPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título con el nombre del usuario
            Text(
              'Bienvenido $username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Párrafo explicativo
            Text(
              'En esta página puedes registrar tus consumos diarios de alimentos '
              'y revisar la gamificación para ver qué recompensas puedes obtener.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            // Botón para ir a la página de gamificación
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamificationPage()),
                );
              },
              child: Text('Ir a Gamification Page'),
            ),
            SizedBox(height: 20),
            // Botón para ir a la encuesta diaria de consumo
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyPage()),
                );
              },
              child: Text('Realizar Encuesta Diaria de Consumo'),
            ),
            SizedBox(height: 20),
            // Botón para el registro de datos de consumo diario
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyIntakePage()),
                );
              },
              child: Text('Registrar Datos de Consumo Diario'),
            ),
          ],
        ),
      ),
    );
  }
}
