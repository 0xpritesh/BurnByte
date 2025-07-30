import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burnbyte/screens/splash/dashboradscreen/Progress.dart';
import 'package:burnbyte/screens/splash/dashboradscreen/calories.dart';
import 'package:burnbyte/screens/splash/dashboradscreen/distance.dart';
import 'package:burnbyte/screens/splash/dashboradscreen/goal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _steps = 0;
  int _goalSteps = 10000;
  double _calories = 0.0;
  double _distance = 0.0;

  late Stream<StepCount> _stepCountStream;
  late AnimationController _animationController;
  late Animation<double> _animation;

  String _day = '';
  String _date = '';

  int _previousStepCount = 0;

  final List<Color> _backgroundGradients = [
    Colors.purple.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.green.shade100,
  ];

  late Color _bgStartColor;
  late Color _bgEndColor;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _requestPermissions().then((_) => _initStepCounter());
    _updateDate();
    _initAnimation();
    _setDynamicBackground();
  }

  void _setDynamicBackground() {
    final now = DateTime.now();
    int index = now.day % _backgroundGradients.length;
    _bgStartColor = _backgroundGradients[index];
    _bgEndColor =
        _backgroundGradients[(index + 1) % _backgroundGradients.length];
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      await Permission.activityRecognition.request();
    }
  }

  void _initStepCounter() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  Future<void> _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String? lastDate = prefs.getString('lastDate');
    if (lastDate != today) {
      _previousStepCount = event.steps;
      await prefs.setInt('baseSteps', _previousStepCount);
      await prefs.setString('lastDate', today);
    } else {
      _previousStepCount = prefs.getInt('baseSteps') ?? event.steps;
    }

    int todaySteps = event.steps - _previousStepCount;
    double calories = todaySteps * 0.04;
    double distance = todaySteps * 0.0008;

    setState(() {
      _steps = todaySteps;
      _calories = calories;
      _distance = distance;
    });

    await prefs.setInt('steps', todaySteps);
    await prefs.setDouble('calories', calories);
    await prefs.setDouble('distance', distance);
  }

  void _onStepCountError(error) {
    print('Step count error: $error');
    setState(() {
      _steps = 0;
      _distance = 0;
      _calories = 0;
    });
  }

  void _updateDate() {
    final now = DateTime.now();
    _day = DateFormat('EEEE').format(now);
    _date = DateFormat('dd MMM yyyy').format(now);
  }

  Future<void> _loadSavedData() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  setState(() {
    _goalSteps = prefs.getInt('daily_goal') ?? 10000;
  });

  if (prefs.getString('lastDate') == today) {
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _calories = prefs.getDouble('calories') ?? 0.0;
      _distance = prefs.getDouble('distance') ?? 0.0;
    });
  }
}


  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(extendBodyBehindAppBar: true,
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.black),
        tooltip: 'Logout',
        onPressed: () async {
          bool? confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Logout"),
                ),
      ]));
                      if (confirm == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login'); // Make sure this route is set
            }
          }
        },
      )
    ],
  ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgStartColor, _bgEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "$_day, $_date",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: screenHeight * 0.3,
                    width: screenHeight * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.deepPurpleAccent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Steps",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        Text(
                          "$_steps",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildInfoCard(
                        "Calories",
                        "${_calories.toStringAsFixed(2)} kcal",
                        Icons.local_fire_department,
                        Colors.orange,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Calories()),
                          );
                        },
                      ),
                      _buildInfoCard(
                        "Distance",
                        "${_distance.toStringAsFixed(2)} km",
                        Icons.map,
                        Colors.blue,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Distance()),
                          );
                        },
                      ),
                      _buildInfoCard(
                        "Goal",
                        "${_goalSteps.toString()} steps",
                        Icons.flag,
                        Colors.green,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Goal()),
                          ).then((_) => _loadSavedData()); // Refresh on return
                        },
                      ),

                      _buildInfoCard(
                        "Progress",
                        "${((_steps / _goalSteps) * 100).clamp(0, 100).toStringAsFixed(1)}%",
                        Icons.show_chart,
                        Colors.teal,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Progress()),
                          );
                        },
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
