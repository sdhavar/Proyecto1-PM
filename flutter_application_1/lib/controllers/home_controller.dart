import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {
  double _percentage = 67.0;

  double get percentage => _percentage;

  void updatePercentage(double newPercentage) {
    _percentage = newPercentage;
    notifyListeners();
  }
}
