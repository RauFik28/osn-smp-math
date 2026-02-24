import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {

  final List<Map<String, dynamic>> userAnswers;
  final int score;

  const ResultScreen({
    super.key,
    required this.userAnswers,
    required this.score,
  });

  Future<void> saveScore() async {

    final prefs = await SharedPreferences.getInstance();

    List<String> history =
        prefs.getStringList("score_history") ?? [];

    history.add(jsonEncode({
      "score": score,
      "date": DateTime.now().toString()
    }));

    await prefs.setStringList("score_history", history);

  }

  @override
  Widget build(BuildContext context) {

    saveScore();

    Map<String, int> categoryCorrect = {};
    Map<String, int> categoryTotal = {};

    for (var item in userAnswers) {

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
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Text(
              "Skor Anda: $score / 20",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [

                  const Text(
                    "Statistik Per Kategori:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...categoryTotal.keys.map((category) {

                    int total = categoryTotal[category]!;
                    int correct =
                        categoryCorrect[category] ?? 0;

                    return Text(
                      "$category: $correct / $total benar",
                    );

                  }),

                ],
              ),
            )

          ],

        ),
      ),

    );

  }

}
