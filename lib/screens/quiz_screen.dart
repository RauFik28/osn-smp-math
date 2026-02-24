import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  List<Map<String, dynamic>> questions = [];
  List<Map<String, dynamic>> userAnswers = [];

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

  Future<void> loadQuestions() async {
    final data = await rootBundle.loadString('assets_questions.json');

    List all = json.decode(data);

    all.shuffle(); // FIX: sebelumnya question.shuffle()

    setState(() {
      questions = List<Map<String, dynamic>>.from(all.take(20));
    });

    startTimer();
  }

  void startTimer() {
    countdown?.cancel();

    countdown = Timer.periodic(Duration(seconds: 1), (t) {
      if (timer == 0) {
        nextQuestion();
      } else {
        setState(() {
          timer--;
        });
      }
    });
  }

  void nextQuestion() {

    countdown?.cancel();

    // simpan jawaban user
    userAnswers.add({
      "question": questions[currentIndex]["soal"],
      "selected": selected ?? "",
      "correct": questions[currentIndex]["jawaban"]
    });

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var q = questions[currentIndex];

    return Scaffold(

      appBar: AppBar(
        title: Text("Soal ${currentIndex + 1}/20"),
      ),

      body: Padding(

        padding: EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Waktu: $timer detik",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),

            SizedBox(height: 16),

            Text(
              q['soal'],
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 16),

            ...['A','B','C','D','E'].map((opt) {

              return RadioListTile<String>(

                title: Text(q['opsi$opt'] ?? ""),

                value: opt,

                groupValue: selected,

                onChanged: (val) {
                  setState(() {
                    selected = val;
                  });
                },

              );

            }).toList(),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: nextQuestion,
              child: Text("Selanjutnya"),
            )

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    countdown?.cancel();
    super.dispose();
  }

}
