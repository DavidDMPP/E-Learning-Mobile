import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/quiz.dart';
import '../../widgets/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() async {
    final quizzes = await DatabaseService().getQuizzes();
    setState(() {
      _quizzes = quizzes;
    });
  }

  void _answerQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _quizzes.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    String resultText;
    if (_score <= 1) {
      resultText = 'Need to learn more';
    } else if (_score == 2) {
      resultText = 'Good';
    } else {
      resultText = 'Very good';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Result'),
          content: Text('Your score: $_score\n$resultText'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: _quizzes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : QuizQuestion(
              quiz: _quizzes[_currentQuestionIndex],
              onAnswer: _answerQuestion,
            ),
    );
  }
}