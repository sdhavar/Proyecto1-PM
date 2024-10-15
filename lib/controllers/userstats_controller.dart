class UserStatsController {
  final List<Map<String, dynamic>> userStats = [
    {'title': 'Sueño', 'value': '0 horas'},
    {'title': 'Agua', 'value': '0 litros'},
    {'title': 'Caminata', 'value': '0 pasos'},
    {'title': 'Peso', 'value': '0 kg'},
    {'title': 'Calorías', 'value': '0 cal'},
    {'title': 'Act. Fis. diaria', 'value': '❌'},
    {'title': 'Cons. Fru./Ver.', 'value': '❌'},
    {'title': 'Evita alim. proc.', 'value': '❌'},
    {'title': 'Consume Alc.', 'value': '❌'},
    {'title': 'Estres freq.', 'value': '❌'},
  ];

  void resetStats() {
    for (var stat in userStats) {
      if (stat['title'] == 'Sueño' ||
          stat['title'] == 'Agua' ||
          stat['title'] == 'Caminata' ||
          stat['title'] == 'Peso' ||
          stat['title'] == 'Calorías') {
        stat['value'] =
            '0 ${stat['title'] == 'Peso' ? 'kg' : stat['title'] == 'Calorías' ? 'cal' : 'horas'}';
      } else {
        stat['value'] = '❌';
      }
    }
  }

  void updateStats(Map<String, dynamic> newStats) {
    userStats[0]['value'] =
        '${int.tryParse(newStats['sleepHours'] ?? '0') ?? 0} horas';
    userStats[1]['value'] =
        '${int.tryParse(newStats['waterIntake'] ?? '0') ?? 0} litros';
    userStats[2]['value'] =
        '${int.tryParse(newStats['steps'] ?? '0') ?? 0} pasos';
    userStats[3]['value'] =
        '${int.tryParse(newStats['weightGoal'] ?? '0') ?? 0} kg';
    userStats[4]['value'] =
        '${int.tryParse(newStats['calories'] ?? '0') ?? 0} cal';

    userStats[5]['value'] =
        newStats['exercise'] == true ? '✔️' : '❌'; 
    userStats[6]['value'] =
        newStats['fruitsVeggies'] == true ? '✔️' : '❌'; 
    userStats[7]['value'] =
        newStats['junkFood'] == true ? '✔️' : '❌'; 
    userStats[8]['value'] =
        newStats['alcohol'] == true ? '✔️' : '❌'; 
    userStats[9]['value'] =
        newStats['stress'] == true ? '✔️' : '❌'; 
  }
}