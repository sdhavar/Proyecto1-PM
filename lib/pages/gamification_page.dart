import 'package:flutter/material.dart';
import 'main_page.dart';

enum UserLevel {
  Beginner,
  Intermediate,
  Advanced,
  Expert,
}

class PointsToLevel {
  static UserLevel getLevel(int points) {
    if (points < 50) {
      return UserLevel.Beginner;
    } else if (points < 100) {
      return UserLevel.Intermediate;
    } else if (points < 150) {
      return UserLevel.Advanced;
    } else {
      return UserLevel.Expert;
    }
  }
}

class Collectible {
  final String name;
  final String description;
  final String imagePath;

  Collectible({required this.name, required this.description, required this.imagePath});
}

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
  List<Collectible> unlockedCollectibles = [];

  final List<Collectible> collectibles = [
    Collectible(name: 'First Steps', description: 'Complete your first task.', imagePath: 'assets/badges/first_steps.png'),
    Collectible(name: 'Goal Crusher', description: 'Complete 10 objectives.', imagePath: 'assets/badges/goal_crusher.png'),
    // More collectibles can be added here...
  ];

  @override
  void initState() {
    super.initState();
    updatedPoints = widget.userPoints;
  }

  UserLevel get currentUserLevel => PointsToLevel.getLevel(updatedPoints);

  void completeObjective(String objectiveName) {
    // Logic for completing an objective...
    if (objectiveName == 'First Steps' && !unlockedCollectibles.contains(collectibles[0])) {
      unlockedCollectibles.add(collectibles[0]);
    } 
    // Add more conditions for additional collectibles...
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
                _buildHeader(context),
                SizedBox(height: 20),
                _buildPointsCard(),
                SizedBox(height: 20),
                _buildRewardsList(context),
                SizedBox(height: 20),
                _buildCollectiblesList(),
                SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
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
              ),
              Text('Tienda de Recompensas',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          // Removed the CircleAvatar with store icon
        ],
      );

  Widget _buildPointsCard() => _buildCard(
        Column(
          children: [
            Text('Puntos acumulados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$updatedPoints', 
                style: TextStyle(
                    fontSize: 48,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Nivel: ${currentUserLevel.toString().split('.').last}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                _showLevelBenefits(context);
              },
              child: Text('Ver beneficios de nivel'),
            ),
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
                    updatedPoints -= cost; 
                  });
                  Navigator.of(context).pop();
                  completeObjective('Descuento en tienda'); // Example of completing an objective
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
          title: Text('¡Ojo!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                    child: Text('Canjear (${reward['cost']} pts)', style: TextStyle(color: Colors.black)), // Changed text color to black
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  void _showLevelBenefits(BuildContext context) {
    String benefits;
    switch (currentUserLevel) {
      case UserLevel.Beginner:
        benefits = 'Bonus: 5 Bonus Points';
        break;
      case UserLevel.Intermediate:
        benefits = 'Bonus: 10 Bonus Points';
        break;
      case UserLevel.Advanced:
        benefits = 'Bonus: 15 Bonus Points';
        break;
      case UserLevel.Expert:
        benefits = 'Bonus: 20 Bonus Points + Exclusive Reward!';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Beneficios de Nivel: ${currentUserLevel.toString().split('.').last}'),
          content: Text(benefits),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCollectiblesList() => _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unlockable Collectibles',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: unlockedCollectibles.map((collectible) {
                return ListTile(
                  title: Text(collectible.name),
                  subtitle: Text(collectible.description),
                  leading: Image.asset(collectible.imagePath, width: 50, height: 50),
                );
              }).toList(),
            ),
          ],
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
