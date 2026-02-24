import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userAnswers;

  const ResultScreen({super.key, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    int correctCount = userAnswers
        .where((item) => item["selected"] == item["correct"])
        .length;

    Map<String, int> categoryCorrect = {};
    Map<String, int> categoryTotal = {};

    for (var item in userAnswers) {
      String category = item["category"];

      categoryTotal[category] = (categoryTotal[category] ?? 0) + 1;

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
              "Skor Anda: $correctCount / 20",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Statistik per kategori
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Statistik Per Kategori:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...categoryTotal.keys.map((category) {
                    int total = categoryTotal[category]!;
                    int correct = categoryCorrect[category] ?? 0;
                    return Text(
                      "$category: $correct / $total benar",
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),

                  const Divider(height: 30),

                  const Text(
                    "Detail Jawaban:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ...userAnswers.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var item = entry.value;
                    bool isCorrect =
                        item["selected"] == item["correct"];

                    return Card(
                      child: ListTile(
                        title: Text("Soal $index (${item["category"]})"),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text("Jawaban Anda: ${item["selected"]}"),
                            Text("Jawaban Benar: ${item["correct"]}"),
                          ],
                        ),
                        trailing: Icon(
                          isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: isCorrect
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
