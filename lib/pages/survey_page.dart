import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController user_sleepHoursController = TextEditingController();
  TextEditingController user_waterIntakeController = TextEditingController();
  TextEditingController user_stepsController = TextEditingController();
  TextEditingController user_caloriesController = TextEditingController();
  TextEditingController user_weightGoalController = TextEditingController();

  bool user_physicalActivity = false;
  bool user_fruitsVegetables = false;
  bool user_avoidProcessedFood = false;
  bool user_alcoholConsumption = false;
  bool user_stressedFrequently = false;

  @override
  void initState() {
    super.initState();
    // Reset the controllers and boolean variables for a fresh start
    user_sleepHoursController.clear();
    user_waterIntakeController.clear();
    user_stepsController.clear();
    user_caloriesController.clear();
    user_weightGoalController.clear();

    user_physicalActivity = false;
    user_fruitsVegetables = false;
    user_avoidProcessedFood = false;
    user_alcoholConsumption = false;
    user_stressedFrequently = false;
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    user_sleepHoursController.dispose();
    user_waterIntakeController.dispose();
    user_stepsController.dispose();
    user_caloriesController.dispose();
    user_weightGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Survey & Daily Intake Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          _buildGradientBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Cuestionario de Salud',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  DailyIntakeInput(
                    hint: 'Cuantas horas duermes al dia?',
                    controller: user_sleepHoursController,
                    validator: (value) =>
                        _validateNumericInput(value, 'sleep hours'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'Cuantos litros de agua consumes diariamente?',
                    controller: user_waterIntakeController,
                    validator: (value) =>
                        _validateNumericInput(value, 'water intake'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'Cuantos pasos das al dia?',
                    controller: user_stepsController,
                    validator: (value) => _validateNumericInput(value, 'steps'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'Cuantas calorias consumes diariamente?',
                    controller: user_caloriesController,
                    validator: (value) =>
                        _validateNumericInput(value, 'calories'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'Meta de peso (Subir/bajar) en kg',
                    controller: user_weightGoalController,
                    validator: (value) => _validateWeightGoalInput(value),
                  ),
                  SizedBox(height: 40),

                  Column(
                    children: [
                      BooleanQuestion(
                        question: 'Haces actividad fisica diariamente?',
                        value: user_physicalActivity,
                        onChanged: (newValue) {
                          setState(() {
                            user_physicalActivity = newValue;
                          });
                        },
                      ),
                      BooleanQuestion(
                        question: 'Consumes frutas y verduras todos los dias?',
                        value: user_fruitsVegetables,
                        onChanged: (newValue) {
                          setState(() {
                            user_fruitsVegetables = newValue;
                          });
                        },
                      ),
                      BooleanQuestion(
                        question: 'Evitas alimentos procesados?',
                        value: user_avoidProcessedFood,
                        onChanged: (newValue) {
                          setState(() {
                            user_avoidProcessedFood = newValue;
                          });
                        },
                      ),
                      BooleanQuestion(
                        question: 'Consumes bebidas alcoholicas regularmente?',
                        value: user_alcoholConsumption,
                        onChanged: (newValue) {
                          setState(() {
                            user_alcoholConsumption = newValue;
                          });
                        },
                      ),
                      BooleanQuestion(
                        question: 'Sientes estres frecuentemente?',
                        value: user_stressedFrequently,
                        onChanged: (newValue) {
                          setState(() {
                            user_stressedFrequently = newValue;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, {
                          'sleepHours': user_sleepHoursController.text,
                          'waterIntake': user_waterIntakeController.text,
                          'steps': user_stepsController.text,
                          'calories': user_caloriesController.text,
                          'weightGoal': user_weightGoalController.text,
                          'exercise': user_physicalActivity,
                          'fruitsVeggies': user_fruitsVegetables,
                          'junkFood': user_avoidProcessedFood,
                          'alcohol': user_alcoholConsumption,
                          'stress': user_stressedFrequently,
                        });
                      }
                    },
                    tooltip: 'Save and continue',
                    iconSize: 30.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateNumericInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return "Digita $field";
    }
    final n = num.tryParse(value);
    if (n == null) {
      return "Valor $field invalido";
    }
    return null; // Valid input
  }

  String? _validateWeightGoalInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Digita meta de peso";
    }
    return null; // Valid input
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
}

// Reusable component for intake input fields
class DailyIntakeInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  DailyIntakeInput({
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
        labelStyle: TextStyle(color: const Color.fromARGB(179, 255, 255, 255)),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(179, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
      validator: validator,
    );
  }
}

// Reusable component for boolean questions
class BooleanQuestion extends StatelessWidget {
  final String question;
  final bool value;
  final Function(bool) onChanged;

  BooleanQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            question,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.greenAccent,
        ),
      ],
    );
  }
}
