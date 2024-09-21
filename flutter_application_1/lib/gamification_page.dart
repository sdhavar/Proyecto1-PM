import 'package:flutter/material.dart';

class GamificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Progreso de Metas'),
            LinearProgressIndicator(value: 0.5), // Ejemplo de barra de progreso
            SizedBox(height: 20),
            Text('Sistema de Puntos'),
            // Aquí puedes añadir más elementos de gamificación
          ],
        ),
      ),
    );
  }
}
