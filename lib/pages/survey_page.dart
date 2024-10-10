import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/survey_controller.dart'; // Importa los controladores de la encuesta

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta de Salud y Registro de Ingesta Diaria'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // Color de fondo del AppBar
      ),
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7fc8f8), Color(0xFF4ba3c7)],
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          // Contenido principal
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Center(
                  child: Text(
                    'Encuesta de Salud',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                DailyIntakeInput(
                  hint: '¿Cuántas horas duermes al día?',
                  controller: user_sleepHoursController,
                ),
                SizedBox(height: 20),
                DailyIntakeInput(
                  hint: '¿Cuántos litros de agua consumes al día?',
                  controller: user_waterIntakeController,
                ),
                SizedBox(height: 20),
                DailyIntakeInput(
                  hint: '¿Cuántos pasos das al día?',
                  controller: user_stepsController,
                ),
                SizedBox(height: 20),
                DailyIntakeInput(
                  hint: '¿Cuántas calorías consumes al día?',
                  controller: user_caloriesController,
                ),
                SizedBox(height: 20),
                DailyIntakeInput(
                  hint: 'Meta de peso (subir/bajar en kg)',
                  controller: user_weightGoalController,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes añadir la lógica para procesar los datos ingresados
                    // Envía los datos de la encuesta de vuelta a la MainPage
                    Navigator.pop(context, {
                      'sleepHours': user_sleepHoursController.text,
                      'waterIntake': user_waterIntakeController.text,
                      'steps': user_stepsController.text,
                      'calories': user_caloriesController.text,
                      'weightGoal': user_weightGoalController.text,
                    });
                  },
                  child: Text('Guardar y Continuar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Componente reutilizable para campos de ingreso
class DailyIntakeInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  DailyIntakeInput({required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
        labelStyle: TextStyle(color: const Color.fromARGB(179, 255, 255, 255)),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(179, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
  }
}
