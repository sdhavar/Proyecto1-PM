import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart'; // Ensure this page is imported correctly
import 'login_page.dart'; // Import your LoginPage here

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
  ];

  String selectedType = 'Específica', goalCategory = 'Cuantitativa';
  int goalQuantity = 0;
  bool goalCompleted = false;
  String goalUnit = ''; // To store the unit of the goal
  String selectedGeneralGoal = 'Sueño'; // Variable for generic goal selection

  void _updateUserStats(Map<String, dynamic> newStats) {
    setState(() {
      userStats[0]['value'] = '${int.tryParse(newStats['sleepHours'] ?? '0') ?? 0} horas';
      userStats[1]['value'] = '${int.tryParse(newStats['waterIntake'] ?? '0') ?? 0} litros';
      userStats[2]['value'] = '${int.tryParse(newStats['steps'] ?? '0') ?? 0} pasos';
      userStats[3]['value'] = '${int.tryParse(newStats['weightGoal'] ?? '0') ?? 0} kg';
      userStats[4]['value'] = '${int.tryParse(newStats['calories'] ?? '0') ?? 0} cal';

      // Add boolean responses to the stats
      userStats.add({'title': 'Act. Fis. diaria', 'value': newStats['exercise'] == true ? '✔️' : '❌'});
      userStats.add({'title': 'Cons. Fru./Ver.', 'value': newStats['fruitsVeggies'] == true ? '✔️' : '❌'});
      userStats.add({'title': 'Evita alim. proc.', 'value': newStats['junkFood'] == true ? '✔️' : '❌'});
      userStats.add({'title': 'Consume Alc.', 'value': newStats['alcohol'] == true ? '✔️' : '❌'});
      userStats.add({'title': 'Estres freq.', 'value': newStats['stress'] == true ? '✔️' : '❌'});
    });
  }

  void _addGoal(String name, dynamic value, String unit) {
    // Add the new goal to userStats directly
    setState(() {
      userStats.add({'title': name, 'value': '$value $unit'}); // Include the unit here
    });
  }

  void _showAddGoalDialog() {
    String goalName = '';
    String goalUnit = ''; // Variable to store the unit
    List<String> generalGoals = ['Sueño', 'Agua', 'Caminata', 'Peso', 'Calorías']; // List of generic goals

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
                onChanged: (newValue) => setState(() => selectedType = newValue!),
                items: ['Específica', 'Genérica']
                    .map((value) => DropdownMenuItem(value: value, child: Text(value)))
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
                  onChanged: (newValue) => setState(() => selectedGeneralGoal = newValue!),
                  items: generalGoals.map((goal) {
                    return DropdownMenuItem(value: goal, child: Text(goal));
                  }).toList(),
                ),
              DropdownButton(
                value: goalCategory,
                onChanged: (newValue) => setState(() => goalCategory = newValue!),
                items: ['Cuantitativa', 'Cualitativa']
                    .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
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
              if (goalName.isNotEmpty || selectedType == 'Genérica') {
                String finalGoalName = selectedType == 'Específica' ? goalName : selectedGeneralGoal;
                if (goalCategory == 'Cuantitativa' && goalQuantity > 0 && goalUnit.isNotEmpty) {
                  _addGoal(finalGoalName, goalQuantity, goalUnit); // Pass the unit as well
                } else if (goalCategory == 'Cualitativa') {
                  _addGoal(finalGoalName, goalCompleted ? 'Sí' : 'No', ''); // No unit for qualitative goals
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor, introduce una cantidad y unidad válida para la meta cuantitativa.'),
                  ));
                }
                Navigator.of(context).pop(); // Close dialog only after adding the goal
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Por favor, completa el nombre de la meta.'),
                ));
              }
            },
            child: Text('Añadir', style: TextStyle(color: Colors.black)), // Changed text color to white
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.black)), // Changed text color to white
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
                userStats.removeAt(index); // Remove the goal at the specified index
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.black)), // Changed text color to white
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text('Cancelar', style: TextStyle(color: Colors.black)), // Changed text color to white
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
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              ); // Navigate to the LoginPage
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056b3), // Background color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                        textStyle: TextStyle(fontSize: 16), // Text style
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamificationPage())),
                      child: Text('Ir a Gamificación', style: TextStyle(color: Colors.white)), // Changed text color to white
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056b3), // Background color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                        textStyle: TextStyle(fontSize: 16), // Text style
                      ),
                      onPressed: () async {
                        // Wait for the response from SurveyPage
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyPage()));
                        if (result != null) {
                          // Update stats with obtained data
                          _updateUserStats(result);
                        }
                      },
                      child: Text('Realizar encuesta', style: TextStyle(color: Colors.white)), // Changed text color to white
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
              icon: Icon(Icons.person, color: Colors.black), // Person icon
              onPressed: _confirmLogout, // Call to confirm logout
            ),
            SizedBox(width: 8), // Spacing between icon and text
            Text(
              '¡Hola ${widget.username}! ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        Text(
          'Aquí están tus estadísticas y metas',
          style: TextStyle(fontSize: 16, color: Colors.black),
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
            Text('Estadísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...userStats.map((stat) {
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
            Text('Metas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: userStats
                  .map((goal) => ListTile(
                        title: Text(goal['title']),
                        subtitle: Text(goal['value']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteGoal(userStats.indexOf(goal)),
                        ),
                      ))
                  .toList(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF0056b3), // Background color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
              ),
              onPressed: _showAddGoalDialog,
              child: Text('Añadir meta', style: TextStyle(color: Colors.white)), // Changed text color to white
            ),
          ],
        ),
      ),
    );
  }
}
