class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });


  static List<Question> get dummyQuestions {
    return [
      Question(
        questionText: 'siapa nama anak Gol D Roger?',
        options: ['Ace', 'Shanks', 'Buggy', 'Garp'],
        correctAnswerIndex: 2, // Dart ada di index ke-2
      ),
      Question(
        questionText: 'siapa yang dijuluki sebagai Fox Sin di anime nanatsu no taizai?',
        options: ['kamado', 'Diane', 'Ban', 'Vanitas'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: 'berapa istri rudeus pada anime mushoku tensei?',
        options: ['6', '1', '2', '3'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: 'siapa yonkou dengan bounty termahal sebelum time skip?',
        options: ['big mom', 'shanks', 'shirohige', 'kurohige'],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: 'disebut apa kaum petinggi dunia ?',
        options: ['supernova', 'kiseki no sedai', 'tenryubito', 'valhalla'],
        correctAnswerIndex: 1,
      ),
    ];
  }
}