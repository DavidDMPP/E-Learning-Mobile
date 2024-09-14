import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizQuestion extends StatelessWidget {
  final Quiz quiz;
  final Function(bool) onAnswer;

  const QuizQuestion({super.key, required this.quiz, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            quiz.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...quiz.options.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              child: Text(option),
              onPressed: () => onAnswer(index == quiz.correctOptionIndex),
            ),
          );
        }),
      ],
    );
  }
}
