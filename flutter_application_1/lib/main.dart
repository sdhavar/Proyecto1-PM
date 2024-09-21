import 'package:flutter/material.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'signup_page.dart';
import 'poll_page.dart';
import 'gamification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Mejor Ser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
