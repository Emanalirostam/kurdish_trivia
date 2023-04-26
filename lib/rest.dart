import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kurdish_trivia/models/category.dart';
import 'package:kurdish_trivia/models/question.dart';

Future<Question> getRandomQuestion() async {
  final response =
      await http.get(Uri.parse('https://opentdb.com/api.php?amount=1'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body)['results'][0];
    return Question.fromJson(data);
  } else {
    throw Exception('Failed to load question');
  }
}

Future<List<Question>> getQuestions(int amount,
    {int? category, String? difficulty, String? type}) async {
  String url = 'https://opentdb.com/api.php?amount=$amount';
  if (category != null) {
    url += '&category=$category';
  }
  if (difficulty != null) {
    url += '&difficulty=$difficulty';
  }
  if (type != null) {
    url += '&type=$type';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body)['results'];
    return List<Question>.from(data.map((x) => Question.fromJson(x)));
  } else {
    throw Exception('Failed to load questions');
  }
}

Future<List<Category>> getCategories() async {
  final response =
      await http.get(Uri.parse('https://opentdb.com/api_category.php'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body)['trivia_categories'];
    return List<Category>.from(data.map((x) => Category.fromJson(x)));
  } else {
    throw Exception('Failed to load categories');
  }
}

List<String> getDifficulties() {
  return ['easy', 'medium', 'hard'];
}
