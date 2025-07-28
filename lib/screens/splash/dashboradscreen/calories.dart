import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calories extends StatefulWidget {
  const Calories({super.key});

  @override
  State<Calories> createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  double _calories = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _calories = prefs.getDouble('calories') ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calories Burned"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          "${_calories.toStringAsFixed(2)} kcal",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
