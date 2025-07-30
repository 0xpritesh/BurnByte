import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  int _goalSteps = 10000;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goalSteps = prefs.getInt('daily_goal') ?? 10000;
      _controller.text = _goalSteps.toString();
    });
  }

  Future<void> _saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal', goal);
  }

  void _updateGoal() {
    final int? enteredGoal = int.tryParse(_controller.text);
    if (enteredGoal != null && enteredGoal > 0) {
      setState(() {
        _goalSteps = enteredGoal;
      });
      _saveGoal(enteredGoal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Goal updated to $enteredGoal steps"),
          backgroundColor: Colors.teal.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid step goal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Set Your Daily Step Goal",style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal
                  ),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFFE0F2F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.directions_walk, size: 50, color: Colors.teal),
                        const SizedBox(height: 15),
                        const Text(
                          "Current Goal",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$_goalSteps steps",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Enter New Goal",
                    labelStyle: const TextStyle(color: Colors.teal),
                    prefixIcon: const Icon(Icons.flag, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updateGoal,
                    icon: const Icon(Icons.check,color: Colors.white),
                    label: const Text(
                      "Update Goal",
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
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
