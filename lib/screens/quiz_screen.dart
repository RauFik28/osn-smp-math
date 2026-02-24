
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  int timer = 180;
  Timer? countdown;
  String? selected;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    final data = await rootBundle.loadString('assets_questions.json');
    List all = json.decode(data);
    question.shuffle();
    setState(() {
      questions = questions.take(20).toList();
    });
    startTimer();
  }

  void startTimer() {
    countdown = Timer.periodic(Duration(seconds: 1), (t) {
      if (timer == 0) {
        nextQuestion();
      } else {
        setState(() => timer--);
      }
    });
  }

  void nextQuestion() {
    countdown?.cancel();
    if (selected == questions[currentIndex]['jawaban']) {
      score++;
    }
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selected = null;
        timer = 180;
      });
      startTimer();
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Try Out Selesai"),
          content: Text("Skor: $score / 20"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Soal ${currentIndex + 1}/20")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Waktu: $timer detik",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(q['soal']),
            ...['A','B','C','D','E'].map((opt) {
              return RadioListTile(
                title: Text(q['opsi'+opt]),
                value: opt,
                groupValue: selected,
                onChanged: (val) {
                  setState(() => selected = val.toString());
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text("Selanjutnya"),
            )
          ],
        ),
      ),
    );
  }
}
