class UserFitnessModel {
  int dailySteps;
  int stepGoal;
  double caloriesBurned;
  DateTime date;

  UserFitnessModel({
    required this.dailySteps,
    required this.stepGoal,
    required this.caloriesBurned,
    required this.date,
  });

  // Convert to Map for local storage (e.g., SharedPreferences or Hive)
  Map<String, dynamic> toMap() {
    return {
      'dailySteps': dailySteps,
      'stepGoal': stepGoal,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  // Create an object from Map
  factory UserFitnessModel.fromMap(Map<String, dynamic> map) {
    return UserFitnessModel(
      dailySteps: map['dailySteps'] ?? 0,
      stepGoal: map['stepGoal'] ?? 10000,
      caloriesBurned: (map['caloriesBurned'] ?? 0.0).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }

  // Helper to reset daily data
  void resetForNewDay() {
    dailySteps = 0;
    caloriesBurned = 0.0;
    date = DateTime.now();
  }

  // Calculate progress %
  double get progressPercent {
    if (stepGoal == 0) return 0.0;
    return (dailySteps / stepGoal).clamp(0.0, 1.0);
  }
}
