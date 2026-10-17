import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  final List<Question> _questions = Question.dummyQuestions;
  int _currentIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;


  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isQuizFinished => _isQuizFinished;

  Question get currentQuestion => _questions[_currentIndex];


  void answerQuestion(int selectedIndex) {

    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      _score += 20;
    }


    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _isQuizFinished = true;
    }

    notifyListeners();
  }


  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    notifyListeners();
  }
}