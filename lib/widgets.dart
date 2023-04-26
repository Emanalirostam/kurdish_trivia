import 'package:flutter/material.dart';
import 'package:kurdish_trivia/models/question.dart';

Widget answerButton(
    {required Answer answer,
    required void Function()? onPressed,
    Color? color}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: color),
    child: Text(
      answer.text,
      style: const TextStyle(fontSize: 16.0),
    ),
  );
}
