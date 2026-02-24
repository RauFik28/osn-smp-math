
import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'history_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HistoryScreen()),
);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Think Math")),
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
