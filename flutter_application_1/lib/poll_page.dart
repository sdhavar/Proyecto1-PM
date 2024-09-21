import 'package:flutter/material.dart';
import 'main_page.dart';

class PollPage extends StatelessWidget {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _weightGoalController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta de Salud y Bienestar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: 'Meta diaria de calorías'),
            ),
            TextField(
              controller: _weightGoalController,
              decoration: InputDecoration(labelText: 'Meta de peso (subir/bajar)'),
            ),
            TextField(
              controller: _stepsController,
              decoration: InputDecoration(labelText: 'Pasos diarios'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes añadir la lógica para guardar las metas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text('Guardar Metas'),
            ),
          ],
        ),
      ),
    );
  }
}
