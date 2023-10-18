class Question {
  final String text;
  final List<Answer> answers;

  const Question({ required this.text, required this.answers });
}

class Answer {
  final String text;
  final bool isCorrect;

  const Answer({ required this.text, required this.isCorrect });
}