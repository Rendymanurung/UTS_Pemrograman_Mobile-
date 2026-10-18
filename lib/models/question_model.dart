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
        questionText: 'Siapa nama anak Gol D Roger?',
        options: ['Ace', 'Shanks', 'Buggy', 'Garp'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: 'Siapa yang dijuluki sebagai Fox Sin di anime Nanatsu no Taizai?',
        options: ['Kamado', 'Diane', 'Ban', 'Vanitas'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Berapa istri Rudeus pada anime Mushoku Tensei?',
        options: ['6', '1', '2', '3'],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: 'Siapa Yonkou dengan bounty termahal sebelum time skip?',
        options: ['Big Mom', 'Shanks', 'Shirohige', 'Kurohige'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Disebut apa kaum petinggi dunia?',
        options: ['Supernova', 'Kiseki no Sedai', 'Tenryubito', 'Valhalla'],
        correctAnswerIndex: 2,
      ),
    ];
  }
}
