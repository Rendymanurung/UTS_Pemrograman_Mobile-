import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  final List<Question> _questions = Question.dummyQuestions;
  int _currentIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  // === Countdown Timer State ===
  static const int maxSecondsPerQuestion = 15;
  int _remainingSeconds = maxSecondsPerQuestion;
  Timer? _timer;
  bool _isTimeUp = false;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isQuizFinished => _isQuizFinished;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get hasAnswered => _hasAnswered;

  int get remainingSeconds => _remainingSeconds;
  bool get isTimeUp => _isTimeUp;
  int get maxSeconds => maxSecondsPerQuestion;

  Question get currentQuestion => _questions[_currentIndex];

  void startTimer() {
    _timer?.cancel();
    _remainingSeconds = maxSecondsPerQuestion;
    _isTimeUp = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isTimeUp = true;
        _hasAnswered = true; // Auto-mark as answered when time expires
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void answerQuestion(int selectedIndex) {
    if (_hasAnswered || _isTimeUp) return;

    stopTimer();
    _selectedAnswerIndex = selectedIndex;
    _hasAnswered = true;

    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      _score += 20;
    }

    notifyListeners();
  }

  void nextQuestion() {
    stopTimer();
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
      _isTimeUp = false;
      startTimer();
    } else {
      _isQuizFinished = true;
    }
    notifyListeners();
  }

  void resetQuiz() {
    stopTimer();
    _currentIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    _selectedAnswerIndex = null;
    _hasAnswered = false;
    _isTimeUp = false;
    startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
