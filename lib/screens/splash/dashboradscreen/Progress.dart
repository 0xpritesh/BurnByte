import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int _steps = 0;
  int _goal = 10000;

  double get _percent => (_steps / _goal).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _loadSteps();
    _loadGoal();
  }

  Future<void> _loadSteps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
    });
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goal = prefs.getInt('daily_goal') ?? 10000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      extendBodyBehindAppBar: true,

       appBar: AppBar(
        title: const Text("Progress"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8edea), Color(0xFFfed6e3)], // dual color bg
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 16.0,
                  animation: true,
                  percent: _percent,
                  center: Text(
                    "${(_percent * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.teal,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Steps Taken: $_steps",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Goal: $_goal steps",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
