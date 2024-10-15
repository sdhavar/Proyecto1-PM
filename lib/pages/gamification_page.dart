import 'package:flutter/material.dart';
import 'main_page.dart';

class GamificationPage extends StatefulWidget {
  final int userPoints; 
  final String username; 
  final int streakDays;

  GamificationPage({required this.userPoints, required this.username, required this.streakDays});

  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  late int updatedPoints;

  @override
  void initState() {
    super.initState();
    updatedPoints = widget.userPoints;
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
                _buildRewardsList(context),
                SizedBox(height: 20),
                _buildBackToMainPageButton(context),
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
                  fontSize: 26,
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
            Text('$updatedPoints', // Update the points displayed
                style: TextStyle(
                    fontSize: 48,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  final List<Map<String, dynamic>> rewards = [
    {'title': 'Descuento en tienda', 'cost': 50},
    {'title': 'Entrenamiento personalizado', 'cost': 100},
    {'title': 'Acceso a gimnasio', 'cost': 150},
    {'title': 'Consulta nutricional', 'cost': 200},
  ];

  void _claimReward(BuildContext context, int cost) {
    if (updatedPoints >= cost) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('¡Recompensa reclamada con éxito!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    updatedPoints -= cost; // Deduct points after claiming a reward
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      _showPopupMessage(context, 'No tienes suficientes puntos.');
    }
  }

  void _showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRewardsList(BuildContext context) => _buildCard(
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
                    onPressed: () => _claimReward(context, reward['cost']),
                    child: Text('Canjear (${reward['cost']} pts)'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget _buildBackToMainPageButton(BuildContext context) => Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  username: widget.username,
                ),
              ),
            );
          },
          child: Text('Volver a la página principal'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFF4ba3c7),
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
