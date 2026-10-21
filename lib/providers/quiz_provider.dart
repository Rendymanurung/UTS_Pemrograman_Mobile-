import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  final List<Question> _questions = Question.dummyQuestions;
  int _currentIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isQuizFinished => _isQuizFinished;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get hasAnswered => _hasAnswered;

  Question get currentQuestion => _questions[_currentIndex];

  void answerQuestion(int selectedIndex) {
    if (_hasAnswered) return;

    _selectedAnswerIndex = selectedIndex;
    _hasAnswered = true;

    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      _score += 20;
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
    } else {
      _isQuizFinished = true;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    _selectedAnswerIndex = null;
    _hasAnswered = false;
    notifyListeners();
  }
}