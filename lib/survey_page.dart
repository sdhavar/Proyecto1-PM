import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/survey_controller.dart'; // Importa los controladores

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Encuesta de Salud',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSwitch('¿Desayunas todos los días?', user_breakfast, (value) {
              setState(() {
                user_breakfast = value; // Usa el controlador importado
              });
            }),
            SizedBox(height: 20),
            _buildSwitch('¿Fumas?', user_smoke, (value) {
              setState(() {
                user_smoke = value; // Usa el controlador importado
              });
            }),
            SizedBox(height: 20),
            _buildSwitch('¿Consumes alcohol?', user_alcohol, (value) {
              setState(() {
                user_alcohol = value; // Usa el controlador importado
              });
            }),
            SizedBox(height: 20),
            _buildSwitch('¿Consumes comida chatarra?', user_junkFood, (value) {
              setState(() {
                user_junkFood = value; // Usa el controlador importado
              });
            }),
            SizedBox(height: 20),
            _buildSwitch('¿Gestionas tu estrés diariamente?', user_stressManagement, (value) {
              setState(() {
                user_stressManagement = value; // Usa el controlador importado
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
