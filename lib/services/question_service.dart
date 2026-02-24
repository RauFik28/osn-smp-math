import 'dart:convert';
import 'package:flutter/services.dart';

class QuestionService {
  static List<dynamic>? _cachedQuestions;

  static Future<List<dynamic>> getQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    final data =
        await rootBundle.loadString('assets/assets_questions.json');

    _cachedQuestions = json.decode(data);
    return _cachedQuestions!;
  }
}
