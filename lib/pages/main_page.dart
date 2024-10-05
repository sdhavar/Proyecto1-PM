import 'package:flutter/material.dart';
import 'gamification_page.dart';
import 'survey_page.dart';
import 'daily_intake_page.dart';

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

  int _currentIndex = 0;

  void _addGoal(String type, String name, int quantity) {
    // Aquí puedes agregar la lógica para manejar la adición de metas
    setState(() {
      if (type == 'Específica') {
        userStats.add({'title': name, 'value': quantity});
      } else {
        userStats.add({'title': 'Meta Genérica', 'value': quantity}); // Cambiar según las opciones predefinidas
      }
    });
    Navigator.of(context).pop(); // Cerrar el diálogo
  }

  void _showAddGoalDialog() {
    String selectedType = 'Específica';
    String goalName = '';
    int goalQuantity = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir Meta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['Específica', 'Genérica']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (selectedType == 'Específica') ...[
                TextField(
                  onChanged: (value) {
                    goalName = value;
                  },
                  decoration: InputDecoration(labelText: 'Nombre de la Meta'),
                ),
              ] else ...[
                DropdownButton<String>(
                  onChanged: (String? newValue) {
                    // Cambiar según las opciones predefinidas
                  },
                  items: <String>['Opción 1', 'Opción 2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
              TextField(
                onChanged: (value) {
                  goalQuantity = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Cantidad de la Meta'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if ((selectedType == 'Específica' && goalName.isNotEmpty && goalQuantity > 0) ||
                    (selectedType == 'Genérica' && goalQuantity > 0)) {
                  _addGoal(selectedType, goalName, goalQuantity);
                } else {
                  // Mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa todos los campos correctamente.')),
                  );
                }
              },
              child: Text('Añadir'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
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
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF92a8d1), Color(0xFFf7cac9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          // Círculos decorativos
          Positioned(
            top: 30,
            left: 50,
            child: Circle(
              diameter: 100,
              color: Color(0xFF034f84),
            ),
          ),
          Positioned(
            top: 150,
            right: 30,
            child: Circle(
              diameter: 120,
              color: Color(0xFFf7786b),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: Circle(
              diameter: 180,
              color: Color(0xFF92a8d1),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 80,
            child: Circle(
              diameter: 100,
              color: Color(0xFFf7cac9),
            ),
          ),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Encabezado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, ${widget.username}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Sigue avanzando y mantente saludable.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF034f84),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  // Tarjeta de estadísticas
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Estadísticas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemCount: userStats.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF034f84),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userStats[index]['title'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${userStats[index]['value']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _showAddGoalDialog,
                          child: Text('+ Añadir Meta'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tarjetas de actividad (cambiado a Metas)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Metas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: userStats.map((goal) {
                            return ListTile(
                              title: Text(goal['title']),
                              trailing: Text('${goal['value']}'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón para gamificación
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GamificationPage()),
                      );
                    },
                    child: Text('Ir a Gamificación'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para crear círculos decorativos
class Circle extends StatelessWidget {
  final double diameter;
  final Color color;

  Circle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
