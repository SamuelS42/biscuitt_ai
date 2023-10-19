import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return const QuestionView();
  }
}

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionView();
}

class _QuestionView extends State<QuestionView> {
  String currentQuestionText = "Default Question";
  List<String> currentAnswerText = [
    "Default Answer A",
    "Default Answer B",
    "Default Answer C",
    "Default Answer D"
  ];

  void setQuestion(
      {required String newQuestionText, required List<String> newAnswerText}) {
    setState(() {
      currentQuestionText = newQuestionText;
      currentAnswerText = newAnswerText;
    });
  }

  void answerGuessed(int index) {
    //TODO: implement
    print("Answer #$index guessed: \"${currentAnswerText[index]}\"");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  currentQuestionText,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ] +
            List.generate(
                currentAnswerText.length,
                (i) => Container(
                    padding: const EdgeInsets.all(50),
                    child: ElevatedButton(
                        onPressed: () => answerGuessed(i),
                        child: Text(currentAnswerText[i])))));
  }
}
