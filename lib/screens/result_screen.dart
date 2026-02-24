import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userAnswers;
  final int score;

  const ResultScreen({
    super.key,
    required this.userAnswers,
    required this.score,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState() {
    super.initState();
    saveScore();
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("score_history") ?? [];

    history.add(jsonEncode({
      "score": widget.score,
      "total": widget.userAnswers.length,
      "date": DateTime.now().toString(),
    }));

    await prefs.setStringList("score_history", history);
  }

  @override
  Widget build(BuildContext context) {

    int totalQuestions = widget.userAnswers.length;
    double percentage =
        (widget.score / totalQuestions) * 100;

    Map<String, int> categoryCorrect = {};
    Map<String, int> categoryTotal = {};

    for (var item in widget.userAnswers) {
      String category = item["category"] ?? "Umum";

      categoryTotal[category] =
          (categoryTotal[category] ?? 0) + 1;

      if (item["selected"] == item["correct"]) {
        categoryCorrect[category] =
            (categoryCorrect[category] ?? 0) + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Try Out"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Skor Besar
            Text(
              "${widget.score} / $totalQuestions",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "${percentage.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            // Progress bar
            LinearProgressIndicator(
              value: widget.score / totalQuestions,
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Statistik Per Kategori",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: categoryTotal.keys.map((category) {

                  int total = categoryTotal[category]!;
                  int correct =
                      categoryCorrect[category] ?? 0;

                  double percent =
                      (correct / total) * 100;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 6),
                    child: ListTile(
                      title: Text(category),
                      subtitle: Text(
                          "$correct / $total benar"),
                      trailing: Text(
                        "${percent.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.isFirst);
              },
              child: const Text("Kembali ke Beranda"),
            ),

          ],
        ),
      ),
    );
  }
}
