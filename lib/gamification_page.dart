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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso de Metas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: userPoints / goalPoints, // Progreso basado en los puntos del usuario
            ),
            SizedBox(height: 10),
            Text(
              'Puntos: $userPoints / $goalPoints',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              'Sistema de Puntos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Sección booleanas con botones de reclamar puntos
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

            SizedBox(height: 30),
            Divider(),

            // Sección cuantitativa con barras de progreso y botones
            Text(
              'Metas Cuantitativas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            _buildQuantitativeGoal('Consumo de Agua (litros)', userWaterIntake, waterGoal, 10),
            _buildClaimButton(userWaterIntake >= waterGoal, 'Reclamar Puntos', 10),

            _buildQuantitativeGoal('Calorías Consumidas', userCalories, calorieGoal, 20),
            _buildClaimButton(userCalories >= calorieGoal, 'Reclamar Puntos', 20),

            SizedBox(height: 30),

            // Mostrar la recompensa si está disponible
            if (reward.isNotEmpty)
              Text(
                reward,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            if (reward.isNotEmpty)
              SizedBox(height: 10),
            if (reward.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Puedes agregar más lógica de recompensas aquí
                    reward = ""; // Reiniciamos la recompensa
                    userPoints = 0; // Reiniciamos los puntos
                  });
                },
                child: Text('Reiniciar Progreso'),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar los criterios de puntos
  Widget _buildPointCriteria(String label, bool achieved, int points) {
    return Row(
      children: [
        Icon(
          achieved ? Icons.check_circle : Icons.cancel,
          color: achieved ? Colors.green : Colors.red,
        ),
        SizedBox(width: 10),
        Text(
          '$label (+$points pts)',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Widget para el botón de reclamar puntos
  Widget _buildClaimButton(bool condition, String buttonText, int points) {
    return ElevatedButton(
      onPressed: condition
          ? () {
              setState(() {
                userPoints += points;
              });
            }
          : null, // Solo activar si la condición es verdadera
      child: Text(buttonText),
    );
  }

  // Widget para las metas cuantitativas con barra de progreso
  Widget _buildQuantitativeGoal(String label, double currentValue, double goalValue, int points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label (+$points pts)'),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: currentValue / goalValue, // Progreso basado en el valor actual
        ),
        SizedBox(height: 5),
        Text('${currentValue.toStringAsFixed(1)} / ${goalValue.toStringAsFixed(1)}'),
        SizedBox(height: 10),
      ],
    );
  }
}
