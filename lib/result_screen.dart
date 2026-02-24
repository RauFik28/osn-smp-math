import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveScore(int score) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList("score_history") ?? [];

  history.add(jsonEncode({
    "score": score,
    "date": DateTime.now().toString()
  }));

  await prefs.setStringList("score_history", history);
}

class ResultScreen extends StatelessWidget {

  final List<Map<String, dynamic>> userAnswers;

  const ResultScreen({
    super.key,
    required this.userAnswers
  });

  @override
  Widget build(BuildContext context) {

    int correctCount = userAnswers
        .where((item) => item["selected"] == item["correct"])
        .length;

    saveScore(correctCount);

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
              "Skor Anda: $correctCount / 20",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 20),

            /// CHART (dipindahkan ke dalam build)
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(show: true),
                  barGroups: categoryTotal.keys
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {

                    int index = entry.key;
                    String category = entry.value;

                    int correct =
                        categoryCorrect[category] ?? 0;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: correct.toDouble(),
                        )
                      ],
                    );

                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: ListView(

                children: [

                  const Text(
                    "Detail Jawaban:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...userAnswers
                      .asMap()
                      .entries
                      .map((entry) {

                    int index = entry.key + 1;
                    var item = entry.value;

                    bool isCorrect =
                        item["selected"] ==
                        item["correct"];

                    return Card(

                      child: ListTile(

                        title: Text(
                          "Soal $index (${item["category"]})"
                        ),

                        subtitle: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Jawaban Anda: ${item["selected"]}"
                            ),

                            Text(
                              "Jawaban Benar: ${item["correct"]}"
                            ),

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
