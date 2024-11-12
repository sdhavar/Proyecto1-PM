import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gamification_page.dart';
import 'survey_page.dart';
import 'login_page.dart';
import 'package:flutter_application_1/controllers/userstats_controller.dart';
import 'package:flutter_application_1/controllers/streak_controller.dart';


class MainPage extends StatefulWidget {
  

  final String username; // This will now show the username
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
  final StreakController streakController;

  String selectedType = 'Específica', goalCategory = 'Cuantitativa';
  int goalQuantity = 0;
  String goalUnit = '';
  String? selectedGoal;
  int totalPoints = 0;
  DateTime currentDate = DateTime.now();

  _MainPageState() : streakController = StreakController(currentDate: DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadPointsAndStreak();
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
      userStatsController.resetStats();
      if (streakController.streakDays > 0 && streakController.streakDays % 3 == 0) {
        totalPoints += 50;
        _showStreakNotification();
      }
      _savePointsAndStreak();
    });
  }

  void _showStreakNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Text('Has ganado 50 puntos por tu racha de ${streakController.streakDays} días.'),
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
      userStatsController.userStats.add({'title': name, 'value': '$value $unit'});
    });
  }

  void _showAddGoalDialog() {
    String goalName = '';
    String goalUnit = '';
    bool isCompleted = false;

    List<Map<String, dynamic>> generalGoals = [
      {'name': 'Sueño', 'icon': Icons.nights_stay},
      {'name': 'Agua', 'icon': Icons.water_drop},
      {'name': 'Caminata', 'icon': Icons.directions_walk},
      {'name': 'Peso', 'icon': Icons.fitness_center},
      {'name': 'Calorías', 'icon': Icons.local_fire_department},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Meta'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: Text('Específica'),
                      selected: selectedType == 'Específica',
                      onSelected: (selected) {
                        setState(() {
                          selectedType = 'Específica';
                          selectedGoal = null;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('Genérica'),
                      selected: selectedType == 'Genérica',
                      onSelected: (selected) {
                        setState(() {
                          selectedType = 'Genérica';
                          selectedGoal = null;
                        });
                      },
                    ),
                  ],
                ),
                if (selectedType == 'Específica')
                  TextField(
                    onChanged: (value) => goalName = value,
                    decoration: InputDecoration(labelText: 'Nombre de la Meta'),
                  ),
                if (selectedType == 'Genérica')
                  Column(
                    children: generalGoals.map((goal) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGoal = goal['name'];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedGoal == goal['name'] ? Colors.blue : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(goal['icon'], size: 30, color: Colors.black),
                              SizedBox(height: 5),
                              Text(goal['name']),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: ChoiceChip(
                        label: Text('Cuantitativa'),
                        selected: goalCategory == 'Cuantitativa',
                        onSelected: (selected) {
                          setState(() {
                            goalCategory = 'Cuantitativa';
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: ChoiceChip(
                        label: Text('Cualitativa'),
                        selected: goalCategory == 'Cualitativa',
                        onSelected: (selected) {
                          setState(() {
                            goalCategory = 'Cualitativa';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (goalCategory == 'Cuantitativa')
                  Column(
                    children: [
                      TextField(
                        onChanged: (value) => goalQuantity = int.tryParse(value) ?? 0,
                        decoration: InputDecoration(labelText: 'Cantidad'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        onChanged: (value) => goalUnit = value,
                        decoration: InputDecoration(labelText: 'Unidad (ej. libros, páginas)'),
                      ),
                    ],
                  )
                else if (goalCategory == 'Cualitativa')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('¿Completa?'),
                      Switch(
                        value: isCompleted,
                        onChanged: (value) {
                          setState(() {
                            isCompleted = value;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (goalName.isNotEmpty || selectedGoal != null) {
                String finalGoalName = selectedType == 'Específica' ? goalName : selectedGoal!;
                if (goalCategory == 'Cuantitativa' && goalQuantity > 0 && goalUnit.isNotEmpty) {
                  _addGoal(finalGoalName, goalQuantity, goalUnit);
                } else if (goalCategory == 'Cualitativa') {
                  _addGoal(finalGoalName, isCompleted ? 'Sí' : 'No', '');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor, introduce una cantidad y unidad válida para la meta cuantitativa.'),
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

  void _confirmCompleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Completar Meta'),
        content: Text('¿Estás seguro de que deseas marcar esta meta como completada?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                userStatsController.userStats[index]['completed'] = true;
              });
              Navigator.of(context).pop();
              _showProgressBar();
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
              LinearProgressIndicator(value: 1.0),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      });
    }
  }

  Future<void> _navigateToSurveyPage() async {
    final surveyData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SurveyPage()),
    );

    if (surveyData != null) {
      _updateUserStats(surveyData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(),
          SingleChildScrollView(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.02),
                _buildHeader(),
                SizedBox(height: screenSize.height * 0.02),
                _buildStatsCard(screenSize),
                SizedBox(height: screenSize.height * 0.02),
                _buildGoalsCard(screenSize),
                SizedBox(height: screenSize.height * 0.02),
                _buildStreakWidget(),
                SizedBox(height: screenSize.height * 0.02),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Survey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Gamification',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(username: widget.username)),
            );
          } else if (index == 1) {
            _navigateToSurveyPage();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GamificationPage(
                        streakDays: streakDays,
                        userPoints: totalPoints,
                        username: widget.username,
                      )),
            );
          }
        },
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
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.black),
                    onPressed: _confirmLogout,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '¡Hola ${widget.username}! ', // Display username from email
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(width: 10),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 8),
              Text(
                'Aquí están tus estadísticas y metas',
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                'Fecha actual: ${currentDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Icon(Icons.calendar_today, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Size screenSize) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estadísticas',
                style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...userStatsController.userStats.take(5).map((stat) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(stat['title'], softWrap: true)),
                  Flexible(
                      child: Text(stat['value'], textAlign: TextAlign.end)),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsCard(Size screenSize) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Metas',
                    style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: _showAddGoalDialog,
                  tooltip: 'Añadir meta',
                  color: Color(0xFF0056b3),
                ),
              ],
            ),
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
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department, color: Colors.black, size: 32),
                SizedBox(width: 8),
                Text(
                  '$streakDays días',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
      ],
    );
  }
} 
