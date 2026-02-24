
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OSN SMP Matematika 2025-2026")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => QuizScreen()));
          },
          child: Text("Mulai Try Out (20 Soal Random)"),
        ),
      ),
    );
  }
}
