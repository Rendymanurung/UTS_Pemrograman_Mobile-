class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imagePath;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.imagePath,
  });

  static List<Question> get dummyQuestions {
    return [
      Question(
        questionText: 'Siapa nama anak Gol D Roger?',
        options: ['Ace', 'Shanks', 'Buggy', 'Garp'],
        correctAnswerIndex: 0,
        imagePath: 'assets/images/quiz_1.jpg',
      ),
      Question(
        questionText: 'Siapa yang dijuluki sebagai Fox Sin di anime Nanatsu no Taizai?',
        options: ['Kamado', 'Diane', 'Ban', 'Vanitas'],
        correctAnswerIndex: 2,
        imagePath: 'assets/images/quiz_2.jpg',
      ),
      Question(
        questionText: 'Berapa istri Rudeus pada anime Mushoku Tensei?',
        options: ['6', '1', '2', '3'],
        correctAnswerIndex: 3,
        imagePath: 'assets/images/quiz_3.jpeg',
      ),
      Question(
        questionText: 'Siapa Yonkou dengan bounty termahal sebelum time skip?',
        options: ['Big Mom', 'Shanks', 'Shirohige', 'Kurohige'],
        correctAnswerIndex: 2,
        imagePath: 'assets/images/quiz_4.jpeg',
      ),
      Question(
        questionText: 'Disebut apa kaum petinggi dunia?',
        options: ['Supernova', 'Kiseki no Sedai', 'Tenryubito', 'Valhalla'],
        correctAnswerIndex: 2,
        imagePath: 'assets/images/quiz_5.jpeg',
      ),
    ];
  }
}
