import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gamification_page.dart';
import 'survey_page.dart';
import 'login_page.dart';
import 'package:flutter_application_1/controllers/userstats_controller.dart';
import 'package:flutter_application_1/controllers/streak_controller.dart';

class MainPage extends StatefulWidget {
  final String username;
  MainPage({required this.username});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<String, double> objectiveValues = {
    'Sueño': 8.0,
    'Agua': 5.0,
    'Caminata': 6000.0,
    'Peso': 70.0,
    'Calorías': 3000.0,
  };

  final UserStatsController userStatsController = UserStatsController();
  final StreakController streakController; // Updated to use the new controller

  String selectedType = 'Específica', goalCategory = 'Cuantitativa';
  int goalQuantity = 0;
  String goalUnit = '';
  String selectedGeneralGoal = 'Sueño';
  int totalPoints = 0;
  DateTime currentDate = DateTime.now();

  _MainPageState()
      : streakController = StreakController(currentDate: DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadPointsAndStreak(); // Load points and streak from shared preferences
  }

  void _loadPointsAndStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = prefs.getInt('totalPoints') ?? 0;
      streakController.streakDays = prefs.getInt('streakDays') ?? 0;
    });
  }

  void _savePointsAndStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', totalPoints);
    await prefs.setInt('streakDays', streakController.streakDays);
  }

  void _advanceDays(int days) {
    setState(() {
      streakController.advanceDays(days);
      currentDate = streakController.currentDate;
      userStatsController.resetStats();
      if (streakController.streakDays > 0 &&
          streakController.streakDays % 3 == 0) {
        totalPoints += 50; // Add points on streak milestone
        _showStreakNotification(); // Show notification
      }
      _savePointsAndStreak(); // Save points and streak
    });
  }

  void _showStreakNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Text(
            'Has ganado 50 puntos por tu racha de ${streakController.streakDays} días.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _updateUserStats(Map<String, dynamic> newStats) {
    setState(() {
      userStatsController.updateStats(newStats);
    });
    streakController.updateStreak();
    _savePointsAndStreak();
  }

  int get streakDays => streakController.streakDays;

  void _addGoal(String name, dynamic value, String unit) {
    setState(() {
      userStatsController.userStats
          .add({'title': name, 'value': '$value $unit'});
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
                  _addGoal(finalGoalName, 'No', '');
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
                userStatsController.userStats.removeAt(index);
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

  void _confirmCompleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Completar Meta'),
        content: Text(
            '¿Estás seguro de que deseas marcar esta meta como completada?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                userStatsController.userStats[index]['completed'] =
                    true; // Mark as completed
              });
              Navigator.of(context).pop();
              _showProgressBar(); // Show the progress bar
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void _showProgressBar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Progreso de Compleción'),
              SizedBox(height: 10),
              LinearProgressIndicator(value: 1.0), // Simulate completion
              SizedBox(height: 10),
              Text('¡Meta completada!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
                                  streakDays: streakDays,
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
                          style: TextStyle(color: Colors.white)),
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
    return SingleChildScrollView(
      // Add this line
      scrollDirection: Axis.horizontal, // This allows horizontal scrolling
      child: Row(
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
          Text(
              'Fecha actual: ${currentDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16)),
          ElevatedButton(
            onPressed: () => _advanceDays(1),
            child: Text('Avanzar 1 día'),
          ),
          ElevatedButton(
            onPressed: () => _advanceDays(7),
            child: Text('Avanzar 7 días'),
          ),
        ],
      ),
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
            ...userStatsController.userStats.take(5).map((stat) {
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
              children: userStatsController.userStats
                  .map((goal) => ListTile(
                        title: Text(goal['title']),
                        subtitle: Text(goal['value']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => _confirmCompleteGoal(
                                  userStatsController.userStats.indexOf(goal)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeleteGoal(
                                  userStatsController.userStats.indexOf(goal)),
                            ),
                          ],
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
