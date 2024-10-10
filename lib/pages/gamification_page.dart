import 'package:flutter/material.dart';
import 'main_page.dart'; // Asegúrate de que MainPage esté correctamente importada

class GamificationPage extends StatefulWidget {
  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  int userPoints = 200; // Puedes obtener estos puntos desde el backend o un controlador
  final List<Map<String, dynamic>> rewards = [
    {'title': 'Descuento en tienda', 'cost': 50},
    {'title': 'Entrenamiento personalizado', 'cost': 100},
    {'title': 'Acceso a gimnasio', 'cost': 150},
    {'title': 'Consulta nutricional', 'cost': 200},
  ];

  void _claimReward(int cost) {
    if (userPoints >= cost) {
      setState(() {
        userPoints -= cost;
      });
      _showPopupMessage('¡Recompensa reclamada con éxito!');
    } else {
      _showPopupMessage('No tienes suficientes puntos.');
    }
  }

  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                _buildHeader(),
                SizedBox(height: 20),
                _buildPointsCard(),
                SizedBox(height: 20),
                _buildRewardsList(),
                SizedBox(height: 20),
                _buildBackToMainPageButton(), // Añadimos el botón aquí
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF92a8d1), Color(0xFFf7cac9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Tienda de Recompensas',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          CircleAvatar(
            backgroundColor: Color(0xFF034f84),
            child: Icon(Icons.store, color: Colors.white, size: 32),
          ),
        ],
      );

  Widget _buildPointsCard() => _buildCard(
        Column(
          children: [
            Text('Puntos acumulados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$userPoints',
                style: TextStyle(
                    fontSize: 48,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildRewardsList() => _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recompensas disponibles',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: rewards.map((reward) {
                return ListTile(
                  title: Text(reward['title']),
                  trailing: ElevatedButton(
                    onPressed: () => _claimReward(reward['cost']),
                    child: Text('Canjear (${reward['cost']} pts)'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget _buildBackToMainPageButton() => _buildCard(
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage(username: '',)),
              );
            },
            icon: Icon(Icons.arrow_back),
            label: Text('Volver a la página principal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF034f84),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      );

  Widget _buildCard(Widget child) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7)
          ],
        ),
        child: child,
      );
}
