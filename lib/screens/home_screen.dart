import 'package:flutter/material.dart';
import '../services/question_service.dart';
import 'quiz_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Think Math"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final questions = await QuestionService.getQuestions();
            questions.shuffle();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  questions: questions.take(20).toList(),
                ),
              ),
            );
          },
          child: const Text("Mulai Try Out (20 Soal Random)"),
        ),
      ),
    );
  }
}
