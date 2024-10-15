import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  final String username;
  MainPage({required this.username});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> userStats = [
    {'title': 'Sueño', 'value': '0 horas'},
    {'title': 'Agua', 'value': '0 litros'},
    {'title': 'Caminata', 'value': '0 pasos'},
    {'title': 'Peso', 'value': '0 kg'},
    {'title': 'Calorías', 'value': '0 cal'},
    {'title': 'Act. Fis. diaria', 'value': '❌'}, // Initialized as not done
    {'title': 'Cons. Fru./Ver.', 'value': '❌'}, // Initialized as not done
    {'title': 'Evita alim. proc.', 'value': '❌'}, // Initialized as not done
    {'title': 'Consume Alc.', 'value': '❌'}, // Initialized as not done
    {'title': 'Estres freq.', 'value': '❌'}, // Initialized as not done
  ];

  String selectedType = 'Específica', goalCategory = 'Cuantitativa';
  int goalQuantity = 0;
  String goalUnit = '';
  String selectedGeneralGoal = 'Sueño';
  int totalPoints = 0;
  DateTime currentDate = DateTime.now();
  int streakDays = 0;
  DateTime? lastSurveyDate;

  void _advanceDays(int days) {
    setState(() {
      currentDate = currentDate.add(Duration(days: days));
      if (lastSurveyDate != null) {
        // Check if a day passed since the last survey
        if (currentDate.difference(lastSurveyDate!).inDays > 1) {
          streakDays = 0; // Reset the streak if a day was missed
        } else {
          streakDays += 1; // Increment streak for continuous days
        }
      } else {
        // If this is the first day advancing, initialize streakDays
        streakDays = 1;
      }
      lastSurveyDate = currentDate; // Update the last survey date

      // Reset boolean values and quantitative values to 0
      for (var stat in userStats) {
        if (stat['title'] == 'Sueño' ||
            stat['title'] == 'Agua' ||
            stat['title'] == 'Caminata' ||
            stat['title'] == 'Peso' ||
            stat['title'] == 'Calorías') {
          stat['value'] = '0 ${stat['title'] == 'Peso' ? 'kg' : stat['title'] == 'Calorías' ? 'cal' : 'horas'}'; // Assuming correct units
        } else {
          stat['value'] = '❌'; // Resetting boolean indicators
        }
      }
    });
  }

  void _updateUserStats(Map<String, dynamic> newStats) {
    setState(() {
      userStats[0]['value'] =
          '${int.tryParse(newStats['sleepHours'] ?? '0') ?? 0} horas';
      userStats[1]['value'] =
          '${int.tryParse(newStats['waterIntake'] ?? '0') ?? 0} litros';
      userStats[2]['value'] =
          '${int.tryParse(newStats['steps'] ?? '0') ?? 0} pasos';
      userStats[3]['value'] =
          '${int.tryParse(newStats['weightGoal'] ?? '0') ?? 0} kg';
      userStats[4]['value'] =
          '${int.tryParse(newStats['calories'] ?? '0') ?? 0} cal';

      userStats[5]['value'] = newStats['exercise'] == true ? '✔️' : '❌'; // Act. Fis. diaria
      userStats[6]['value'] = newStats['fruitsVeggies'] == true ? '✔️' : '❌'; // Cons. Fru./Ver.
      userStats[7]['value'] = newStats['junkFood'] == true ? '✔️' : '❌'; // Evita alim. proc.
      userStats[8]['value'] = newStats['alcohol'] == true ? '✔️' : '❌'; // Consume Alc.
      userStats[9]['value'] = newStats['stress'] == true ? '✔️' : '❌'; // Estres freq.
    });
    _updateStreak();
  }

  void _updateStreak() {
    if (lastSurveyDate == null || currentDate.difference(lastSurveyDate!).inDays > 1) {
      // Reset streak if not filled for more than a day
      streakDays = 1; // Start streak as this is the first day
    } else {
      streakDays += 1; // Increment streak
    }
    lastSurveyDate = currentDate; // Update the last survey date
  }

  void _addGoal(String name, dynamic value, String unit) {
    setState(() {
      userStats.add({'title': name, 'value': '$value $unit'});
    });
  }

  void _showAddGoalDialog() {
    String goalName = '';
    String goalUnit = '';
    List<String> generalGoals = [
      'Sueño',
      'Agua',
      'Caminata',
      'Peso',
      'Calorías'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Meta'),
        content: StatefulBuilder(
          builder: (context, setState) =>
              Column(
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
                  if (selectedType == 'Genérica')
                    DropdownButton(
                      value: selectedGeneralGoal,
                      onChanged: (newValue) =>
                          setState(() => selectedGeneralGoal = newValue!),
                      items: generalGoals.map((goal) {
                        return DropdownMenuItem(value: goal, child: Text(goal));
                      }).toList(),
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
                    Column(
                      children: [
                        TextField(
                          onChanged: (value) =>
                              goalQuantity = int.tryParse(value) ?? 0,
                          decoration: InputDecoration(labelText: 'Cantidad'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          onChanged: (value) => goalUnit = value,
                          decoration: InputDecoration(
                              labelText: 'Unidad (ej. libros, páginas)'),
                        ),
                      ],
                    )
                  else
                    SwitchListTile(
                      title: Text('Cumplida'),
                      value: false,
                      onChanged: (value) {},
                    ),
                ],
              ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (goalName.isNotEmpty || selectedType == 'Genérica') {
                String finalGoalName = selectedType == 'Específica'
                    ? goalName
                    : selectedGeneralGoal;
                if (goalCategory == 'Cuantitativa' &&
                    goalQuantity > 0 &&
                    goalUnit.isNotEmpty) {
                  _addGoal(finalGoalName, goalQuantity, goalUnit);
                } else if (goalCategory == 'Cualitativa') {
                  _addGoal(finalGoalName, 'No', ''); // Assuming no initial completion
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Por favor, introduce una cantidad y unidad válida para la meta cuantitativa.'),
                  ));
                }
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Por favor, completa el nombre de la meta.'),
                ));
              }
            },
            child: Text('Añadir', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar esta meta?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                userStats.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar cierre de sesión'),
        content: Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
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
                _buildStreakWidget(),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056b3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamificationPage(
                                  userPoints: totalPoints,
                                  username: widget.username))),
                      child: Text('Ir a Gamificación',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056b3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyPage()));
                        if (result != null) {
                          _updateUserStats(result);
                        }
                      },
                      child: Text('Realizar encuesta',
                          style: TextStyle(
                              color:
                                  Colors.white)), // Changed text color to white
                    ),
                  ],
                ),
                SizedBox(height: 40),
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
      );

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: _confirmLogout,
            ),
            SizedBox(width: 8),
            Text(
              '¡Hola ${widget.username}! ',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        Text(
          'Aquí están tus estadísticas y metas',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text('Fecha actual: ${currentDate.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 16)),
        ElevatedButton(
          onPressed: () => _advanceDays(1), // Avanza 1 día
          child: Text('Avanzar 1 día'),
        ),
        ElevatedButton(
          onPressed: () => _advanceDays(7), // Avanza 7 días
          child: Text('Avanzar 7 días'),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estadísticas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...userStats.take(5).map((stat) { // Only show the first 5 statistical entries
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stat['title']),
                  Text(stat['value']),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: userStats
                  .map((goal) => ListTile(
                        title: Text(goal['title']),
                        subtitle: Text(goal['value']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _confirmDeleteGoal(userStats.indexOf(goal)),
                        ),
                      ))
                  .toList(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF0056b3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              onPressed: _showAddGoalDialog,
              child: Text('Añadir meta', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (streakDays >= 3)
          Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.red, size: 32),
              SizedBox(width: 8),
              Text(
                '$streakDays días',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
      ],
    );
  }
}
