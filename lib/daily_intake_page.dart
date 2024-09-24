import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/daily_intake_controller.dart'; // Importa los controladores

class DailyIntakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Registro de Ingesta Diaria',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }
}
