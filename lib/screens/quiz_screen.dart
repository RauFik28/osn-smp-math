import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentIndex = 0;
  int score = 0;
  String? selected;
  List<Map<String, dynamic>> userAnswers = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data =
        await rootBundle.loadString('assets/assets_questions.json');
    final List<dynamic> decoded = json.decode(data);

    setState(() {
      questions = decoded;
    });
  }

  void nextQuestion() {
    if (selected == null) return;

    final currentQuestion = questions[currentIndex];

    // Simpan jawaban user
    userAnswers.add({
      "question": currentQuestion["question"],
      "selected": selected,
      "correct": currentQuestion["answer"],
      "category": currentQuestion["category"],
    });

    // Hitung skor
    if (selected == currentQuestion["answer"]) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selected = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            userAnswers: userAnswers,
            score: score,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soal ${currentIndex + 1}/${questions.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              q["question"],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // List opsi
            ...(q["options"] as List).map((opt) {
              return RadioListTile<String>(
                title: Text(opt),
                value: opt,
                groupValue: selected,
                onChanged: (val) {
                  setState(() {
                    selected = val;
                  });
                },
              );
            }).toList(),

            const Spacer(),

            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text("Selanjutnya"),
            ),
          ],
        ),
      ),
    );
  }
}
