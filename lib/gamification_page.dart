import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/survey_controller.dart'; // Importamos los controladores de la encuesta

class GamificationPage extends StatefulWidget {
  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  int userPoints = 0;
  int goalPoints = 100; // Meta de puntos para una recompensa
  String reward = ""; // Recompensa

  // Ejemplos de valores cuantitativos (puedes enlazar con los controladores reales)
  double userWaterIntake = 1.5; // Ejemplo: 1.5 litros de agua consumidos
  double waterGoal = 2.0; // Meta de 2 litros

  double userCalories = 1800; // Ejemplo: calorías consumidas
  double calorieGoal = 2000; // Meta de 2000 calorías

  @override
  void initState() {
    super.initState();
    calculatePoints(); // Calcula los puntos basados en las respuestas de la encuesta
  }

  // Lógica para calcular los puntos
  void calculatePoints() {
    int points = 0;

    // Asignamos puntos según las respuestas de la encuesta
    if (user_breakfast) points += 10;
    if (!user_smoke) points += 20;
    if (!user_alcohol) points += 15;
    if (!user_junkFood) points += 10;
    if (user_stressManagement) points += 25;

    setState(() {
      userPoints = points;
    });

    // Verificar si se alcanzó la meta de puntos
    if (userPoints >= goalPoints) {
      setState(() {
        reward = "¡Felicidades! Has ganado una medalla por tu progreso saludable 🎖️";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamificación'),
      ),
      body: Stack(
        children: [
          // Fondo degradado para un efecto más suave
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
          // Círculos decorativos redimensionados y suavizados
          Positioned(
            top: -50,
            left: -30,
            child: Circle(
              diameter: 200,
              color: Color(0xFF003f7f).withOpacity(0.8),
            ),
          ),
          Positioned(
            top: 150,
            right: -50,
            child: Circle(
              diameter: 150,
              color: Color(0xFF0056b3).withOpacity(0.7),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Circle(
              diameter: 150,
              color: Color(0xFF003f7f).withOpacity(0.8),
            ),
          ),
          Positioned(
            bottom: 150,
            right: -30,
            child: Circle(
              diameter: 120,
              color: Color(0xFF0056b3).withOpacity(0.7),
            ),
          ),
          // Contenido principal con diseño más moderno y limpio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Gamificación',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Progreso de Metas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: LinearProgressIndicator(
                      value: userPoints / goalPoints,
                      backgroundColor: Colors.white,
                      color: Colors.greenAccent,
                      minHeight: 10,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Puntos: $userPoints / $goalPoints',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Sistema de Puntos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sección de criterios de puntos con botones para reclamar
                  _buildPointCriteria('Desayunar todos los días', user_breakfast, 10),
                  _buildClaimButton(user_breakfast, 'Reclamar Puntos', 10),
                  _buildPointCriteria('No fumar', !user_smoke, 20),
                  _buildClaimButton(!user_smoke, 'Reclamar Puntos', 20),
                  _buildPointCriteria('No consumir alcohol', !user_alcohol, 15),
                  _buildClaimButton(!user_alcohol, 'Reclamar Puntos', 15),
                  _buildPointCriteria('No consumir comida chatarra', !user_junkFood, 10),
                  _buildClaimButton(!user_junkFood, 'Reclamar Puntos', 10),
                  _buildPointCriteria('Gestionar el estrés', user_stressManagement, 25),
                  _buildClaimButton(user_stressManagement, 'Reclamar Puntos', 25),
                  SizedBox(height: 40),
                  Divider(color: Colors.white60),
                  Text(
                    'Metas Cuantitativas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildQuantitativeGoal('Consumo de Agua (litros)', userWaterIntake, waterGoal, 10),
                  _buildClaimButton(userWaterIntake >= waterGoal, 'Reclamar Puntos', 10),
                  _buildQuantitativeGoal('Calorías Consumidas', userCalories, calorieGoal, 20),
                  _buildClaimButton(userCalories >= calorieGoal, 'Reclamar Puntos', 20),
                  SizedBox(height: 40),
                  if (reward.isNotEmpty)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            reward,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                reward = ""; // Reiniciamos la recompensa
                                userPoints = 0; // Reiniciamos los puntos
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            child: Text('Reiniciar Progreso'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCriteria(String label, bool achieved, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.cancel,
            color: achieved ? Colors.greenAccent : Colors.redAccent,
          ),
          SizedBox(width: 10),
          Text(
            '$label (+$points pts)',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimButton(bool condition, String buttonText, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: condition
            ? () {
                setState(() {
                  userPoints += points;
                });
              }
            : null, // Solo activar si la condición es verdadera
        style: ElevatedButton.styleFrom(
          backgroundColor: condition ? Colors.greenAccent : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(buttonText),
      ),
    );
  }

  Widget _buildQuantitativeGoal(String label, double currentValue, double goalValue, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label (+$points pts)', style: TextStyle(color: Colors.white70, fontSize: 18)),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: currentValue / goalValue,
            backgroundColor: Colors.white30,
            color: Colors.greenAccent,
            minHeight: 10,
          ),
          SizedBox(height: 5),
          Text(
            '${currentValue.toStringAsFixed(1)} / ${goalValue.toStringAsFixed(1)}',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final double diameter;
  final Color color;

  Circle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
