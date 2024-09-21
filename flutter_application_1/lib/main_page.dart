import 'package:flutter/material.dart';
import 'gamification_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GamificationPage()),
            );
          },
          child: Text('Ir a Gamification Page'),
        ),
      ),
    );
  }
}
