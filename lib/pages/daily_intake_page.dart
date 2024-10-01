import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/daily_intake_controller.dart'; // Importa los controladores

class DailyIntakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Ingesta Diaria'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7fc8f8), Color(0xFF4ba3c7)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  'Registro de Ingesta Diaria',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Campos de ingreso
              DailyIntakeInput(
                hint: 'Calorías consumidas',
                controller: user_caloriesController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Meta de peso (subir/bajar)',
                controller: user_weightGoalController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Pasos dados hoy',
                controller: user_stepsController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Litros de agua consumidos',
                controller: user_waterIntakeController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Horas de sueño',
                controller: user_sleepHoursController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Minutos de ejercicio',
                controller: user_exerciseMinutesController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Minutos de meditación',
                controller: user_meditationMinutesController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Porciones de fruta',
                controller: user_fruitIntakeController, // Usa el controlador importado
              ),
              SizedBox(height: 20),
              DailyIntakeInput(
                hint: 'Porciones de vegetales',
                controller: user_vegetableIntakeController, // Usa el controlador importado
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyIntakeInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  DailyIntakeInput({required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white), // Estilo del texto
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
        labelStyle: TextStyle(color: const Color.fromARGB(179, 255, 255, 255)), // Estilo de la etiqueta
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(179, 255, 255, 255)), // Borde blanco
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent), // Borde verde al enfocar
        ),
      ),
    );
  }
}
