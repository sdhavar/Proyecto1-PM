class StreakController {
  DateTime currentDate;
  DateTime? lastSurveyDate;
  int streakDays;

  StreakController({required this.currentDate, this.lastSurveyDate, this.streakDays = 0});

  void advanceDays(int days) {
    currentDate = currentDate.add(Duration(days: days));
    if (lastSurveyDate != null) {
      if (currentDate.difference(lastSurveyDate!).inDays > 1) {
        streakDays = 0;
      } else {
        streakDays += 1;
      }
    } else {
      streakDays = 1;
    }
    lastSurveyDate = currentDate;
  }

  void updateStreak() {
    if (lastSurveyDate == null || currentDate.difference(lastSurveyDate!).inDays > 1) {
      streakDays = 1;
    } else {
      streakDays += 1;
    }
    lastSurveyDate = currentDate;
  }
}
