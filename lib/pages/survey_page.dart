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
      appBar: AppBar(
        title: Text('Encuesta de Salud'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Color de fondo del AppBar
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
                // Preguntas con Switches
                _buildSwitch(
                  '¿Desayunas todos los días?', 
                  user_breakfast, 
                  (value) {
                    setState(() {
                      user_breakfast = value; // Usa el controlador importado
                    });
                  }
                ),
                SizedBox(height: 20),
                _buildSwitch(
                  '¿Fumas?', 
                  user_smoke, 
                  (value) {
                    setState(() {
                      user_smoke = value; // Usa el controlador importado
                    });
                  }
                ),
                SizedBox(height: 20),
                _buildSwitch(
                  '¿Consumes alcohol?', 
                  user_alcohol, 
                  (value) {
                    setState(() {
                      user_alcohol = value; // Usa el controlador importado
                    });
                  }
                ),
                SizedBox(height: 20),
                _buildSwitch(
                  '¿Consumes comida chatarra?', 
                  user_junkFood, 
                  (value) {
                    setState(() {
                      user_junkFood = value; // Usa el controlador importado
                    });
                  }
                ),
                SizedBox(height: 20),
                _buildSwitch(
                  '¿Gestionas tu estrés diariamente?', 
                  user_stressManagement, 
                  (value) {
                    setState(() {
                      user_stressManagement = value; // Usa el controlador importado
                    });
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para crear Switches con estilo
  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.greenAccent,
      inactiveThumbColor: Colors.white70,
      inactiveTrackColor: Colors.white24,
    );
  }
}
