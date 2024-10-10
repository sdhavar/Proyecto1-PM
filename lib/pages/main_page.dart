import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart'; // Asegúrate de que esta página esté importada correctamente

class MainPage extends StatefulWidget {
  final String username;
  MainPage({required this.username});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> userStats = [
    {'title': 'Sueño', 'value': 0},
    {'title': 'Agua', 'value': 0},
    {'title': 'Caminata', 'value': 0},
    {'title': 'Peso', 'value': 0},
    {'title': 'Calorías', 'value': 0},
  ];
  String selectedType = 'Específica', goalCategory = 'Cuantitativa';
  int goalQuantity = 0;
  bool goalCompleted = false;

  void _updateUserStats(Map<String, dynamic> newStats) {
    setState(() {
      userStats[0]['value'] = int.tryParse(newStats['sleepHours'] ?? '0') ?? 0;
      userStats[1]['value'] = int.tryParse(newStats['waterIntake'] ?? '0') ?? 0;
      userStats[2]['value'] = int.tryParse(newStats['steps'] ?? '0') ?? 0;
      userStats[3]['value'] = int.tryParse(newStats['weightGoal'] ?? '0') ?? 0;
      userStats[4]['value'] = int.tryParse(newStats['calories'] ?? '0') ?? 0;

      // Añadir respuestas booleanas a las estadísticas
      userStats.add({
        'title': 'Act. Fis. diaria',
        'value': newStats['exercise'] == true ? '✔️' : '❌'
      });
      userStats.add({
        'title': 'Cons. Fru./Ver.',
        'value': newStats['fruitsVeggies'] == true ? '✔️' : '❌'
      });
      userStats.add({
        'title': 'Evita alim. proc.',
        'value': newStats['junkFood'] == true ? '✔️' : '❌'
      });
      userStats.add({
        'title': 'Consume Alc.',
        'value': newStats['alcohol'] == true ? '✔️' : '❌'
      });
      userStats.add({
        'title': 'Estres freq.',
        'value': newStats['stress'] == true ? '✔️' : '❌'
      });
    });
  }

  void _addGoal(String name, dynamic value) {
    if (mounted) {
      setState(() => userStats.add({'title': name, 'value': value}));
    }
    Navigator.of(context).pop(); // Mover Navigator.pop() después de setState
  }

  void _showAddGoalDialog() {
    String goalName = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Meta'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton(
                value: selectedType,
                onChanged: (newValue) =>
                    setState(() => selectedType = newValue!),
                items: ['Específica', 'Genérica']
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
              ),
              if (selectedType == 'Específica')
                TextField(
                  onChanged: (value) => goalName = value,
                  decoration: InputDecoration(labelText: 'Nombre de la Meta'),
                ),
              DropdownButton(
                value: goalCategory,
                onChanged: (newValue) =>
                    setState(() => goalCategory = newValue!),
                items: ['Cuantitativa', 'Cualitativa']
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
              ),
              if (goalCategory == 'Cuantitativa')
                TextField(
                  onChanged: (value) => goalQuantity = int.tryParse(value) ?? 0,
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                )
              else
                SwitchListTile(
                  title: Text('Cumplida'),
                  value: goalCompleted,
                  onChanged: (value) => setState(() => goalCompleted = value),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (goalName.isNotEmpty) {
                if (goalCategory == 'Cuantitativa' && goalQuantity > 0) {
                  _addGoal(goalName, goalQuantity);
                } else if (goalCategory == 'Cualitativa') {
                  _addGoal(goalName, goalCompleted ? 'Sí' : 'No');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Por favor, introduce una cantidad válida para la meta cuantitativa.'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Por favor, completa el nombre de la meta.'),
                ));
              }
            },
            child: Text('Añadir'),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar')),
        ],
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 40),
                _buildHeader(),
                SizedBox(height: 20),
                _buildStatsCard(),
                SizedBox(height: 40),
                _buildGoalsCard(),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamificationPage())),
                      child: Text('Ir a Gamificación'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Espera la respuesta de SurveyPage
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyPage()));
                        if (result != null) {
                          // Actualiza las estadísticas con los datos obtenidos
                          _updateUserStats(result);
                        }
                      },
                      child: Text('Realizar encuesta'),
                    ),
                  ],
                ),
                SizedBox(
                    height:
                        40), // Espacio al final para evitar que los botones queden pegados al borde
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola, ${widget.username}',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text('Sigue avanzando y mantente saludable.',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Color(0xFF034f84),
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      );

  Widget _buildStatsCard() => _buildCard(
        Column(
          children: [
            Text('Estadísticas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: userStats.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    _buildStatItem(userStats[index]),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: _showAddGoalDialog, child: Text('+ Añadir Meta')),
          ],
        ),
      );

  Widget _buildGoalsCard() => _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Column(
              children: userStats
                  .map((goal) => ListTile(
                      title: Text(goal['title']),
                      trailing: Text('${goal['value']}',
                          style: TextStyle(
                              color: goal['value'] == '✔️'
                                  ? Colors.green
                                  : goal['value'] == '❌'
                                      ? Colors.red
                                      : Colors
                                          .black, // Cambia el color según la respuesta
                              fontSize: 18))))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _buildStatItem(Map<String, dynamic> stat) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 100,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xFF034f84),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(stat['title'], style: TextStyle(color: Colors.white)),
              SizedBox(height: 5),
              Text('${stat['value']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
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
