import 'package:flutter/material.dart';

class Goal extends StatelessWidget {
  const Goal({super.key});

  @override
  Widget build(BuildContext context) {
    int goalSteps = 10000; // You can load this dynamically if needed

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Goal"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "$goalSteps steps",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
