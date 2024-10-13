import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/survey_controller.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation

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
              key: _formKey, // Assign the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Health Survey',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  DailyIntakeInput(
                    hint: 'How many hours do you sleep per day?',
                    controller: user_sleepHoursController,
                    validator: (value) => _validateNumericInput(value, 'sleep hours'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'How many liters of water do you consume daily?',
                    controller: user_waterIntakeController,
                    validator: (value) => _validateNumericInput(value, 'water intake'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'How many steps do you take daily?',
                    controller: user_stepsController,
                    validator: (value) => _validateNumericInput(value, 'steps'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'How many calories do you consume daily?',
                    controller: user_caloriesController,
                    validator: (value) => _validateNumericInput(value, 'calories'),
                  ),
                  SizedBox(height: 20),
                  DailyIntakeInput(
                    hint: 'Weight goal (gain/loss in kg)',
                    controller: user_weightGoalController,
                    validator: (value) => _validateWeightGoalInput(value),
                  ),
                  SizedBox(height: 40),

                  BooleanQuestion(
                    question: 'Do you perform physical activity daily?',
                    value: user_physicalActivity,
                    onChanged: (newValue) {
                      setState(() {
                        user_physicalActivity = newValue;
                      });
                    },
                  ),
                  BooleanQuestion(
                    question: 'Do you consume fruits and vegetables every day?',
                    value: user_fruitsVegetables,
                    onChanged: (newValue) {
                      setState(() {
                        user_fruitsVegetables = newValue;
                      });
                    },
                  ),
                  BooleanQuestion(
                    question: 'Do you avoid processed foods?',
                    value: user_avoidProcessedFood,
                    onChanged: (newValue) {
                      setState(() {
                        user_avoidProcessedFood = newValue;
                      });
                    },
                  ),
                  BooleanQuestion(
                    question: 'Do you consume alcoholic beverages regularly?',
                    value: user_alcoholConsumption,
                    onChanged: (newValue) {
                      setState(() {
                        user_alcoholConsumption = newValue;
                      });
                    },
                  ),
                  BooleanQuestion(
                    question: 'Do you feel stressed frequently?',
                    value: user_stressedFrequently,
                    onChanged: (newValue) {
                      setState(() {
                        user_stressedFrequently = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Validate the form
                      if (_formKey.currentState!.validate()) {
                        // If valid, send data back to MainPage
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
                    child: Text('Save and Continue'),
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
      return "Enter $field";
    }
    final n = num.tryParse(value);
    if (n == null) {
      return "Invalid $field value";
    }
    return null; // Valid input
  }

  String? _validateWeightGoalInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter weight goal";
    }
    // Additional validation for weight can be implemented here if needed
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
          borderSide: BorderSide(color: const Color.fromARGB(179, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
      validator: validator, // Add the validator to the TextFormField
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
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
