import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/poll_controllers.dart';
import 'main_page.dart';


class PollPage extends StatefulWidget {
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  final PollControllers _controllers = PollControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            color: Color(0xFF4ba3c7),
            height: double.infinity,
            width: double.infinity,
          ),
          // Círculos decorativos
          Positioned(
            top: 50,
            left: 20,
            child: Circle(
              diameter: 150,
              color: Color(0xFF003f7f),
            ),
          ),
          Positioned(
            top: 100,
            left: 50,
            child: Circle(
              diameter: 100,
              color: Color(0xFF0056b3),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: Circle(
              diameter: 150,
              color: Color(0xFF003f7f),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 50,
            child: Circle(
              diameter: 100,
              color: Color(0xFF0056b3),
            ),
          ),
          // Nombre de la app
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'Mi Mejor Ser',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Contenido de la encuesta
          Positioned.fill(
            top: 100,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Encuesta de Salud y Bienestar',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    PollInput(
                      icon: Icons.local_fire_department,
                      hint: 'Meta diaria de calorías',
                      controller: _controllers.caloriesController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.fitness_center,
                      hint: 'Meta de peso (subir/bajar)',
                      controller: _controllers.weightGoalController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.directions_walk,
                      hint: 'Pasos diarios',
                      controller: _controllers.stepsController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.local_drink,
                      hint: 'Consumo diario de agua (litros)',
                      controller: _controllers.waterIntakeController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.bedtime,
                      hint: 'Horas de sueño diarias',
                      controller: _controllers.sleepHoursController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.fitness_center,
                      hint: 'Minutos de ejercicio diario',
                      controller: _controllers.exerciseMinutesController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.self_improvement,
                      hint: 'Minutos de meditación diaria',
                      controller: _controllers.meditationMinutesController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.local_florist,
                      hint: 'Porciones de fruta diaria',
                      controller: _controllers.fruitIntakeController,
                    ),
                    SizedBox(height: 20),
                    PollInput(
                      icon: Icons.local_florist,
                      hint: 'Porciones de vegetales diaria',
                      controller: _controllers.vegetableIntakeController,
                    ),
                    SizedBox(height: 20),
                    _buildSwitch('¿Desayunas todos los días?', _controllers.breakfast, (value) {
                      setState(() {
                        _controllers.breakfast = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildSwitch('¿Fumas?', _controllers.smoke, (value) {
                      setState(() {
                        _controllers.smoke = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildSwitch('¿Consumes alcohol?', _controllers.alcohol, (value) {
                      setState(() {
                        _controllers.alcohol = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildSwitch('¿Consumes comida chatarra?', _controllers.junkFood, (value) {
                      setState(() {
                        _controllers.junkFood = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildSwitch('¿Gestionas tu estrés diariamente?', _controllers.stressManagement, (value) {
                      setState(() {
                        _controllers.stressManagement = value;
                      });
                    }),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        // Aquí puedes añadir la lógica para guardar las metas
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c54),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Container(
      width: double.infinity,
      height: 50,  // Reducir la altura del cuadro
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 12))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF4ba3c7),
          ),
        ],
      ),
    );
  }
}

class PollInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;

  PollInput({required this.icon, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,  // Reducir la altura del cuadro
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
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
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
