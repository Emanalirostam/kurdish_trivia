import 'package:html_unescape/html_unescape.dart';

class Question {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  List<Answer>? _answers;

  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: HtmlUnescape().convert(json['question']),
      correctAnswer: HtmlUnescape().convert(json['correct_answer']),
      incorrectAnswers: List<String>.from(
          json['incorrect_answers'].map((e) => HtmlUnescape().convert(e))),
    );
  }

  List<Answer> get answers {
    if (_answers != null) {
      return _answers!;
    }
    List<Answer> answers = List<Answer>.from(
        incorrectAnswers.map((ans) => Answer(text: ans, isCorrect: false)));
    answers.add(Answer(text: correctAnswer, isCorrect: true));
    answers.shuffle();
    _answers = answers;
    return answers;
  }
}

class Answer {
  final String text;
  final bool isCorrect;

  Answer({required this.text, required this.isCorrect});
}
