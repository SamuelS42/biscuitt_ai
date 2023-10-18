import 'package:biscuitt_ai/models/question_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({ super.key });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: QuestionView(),
    );
  }
}

class QuestionText extends StatelessWidget {
  QuestionText({
    required this.text,
  }) : super(key: ObjectKey(text));

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

class AnswerList extends StatelessWidget {
  AnswerList({
    required this.answers,
  }) : super(key: ObjectKey(answers));

  final List<Answer> answers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      shrinkWrap: true,
      itemCount: answers.length,
      itemBuilder: (ctx, i) => AnswerItem(answer: answers[i]));
  }
}

class AnswerItem extends StatefulWidget {
  const AnswerItem({ required this.answer, super.key });

  final Answer answer;

  @override
  State<AnswerItem> createState() => _AnswerItemState();
}

class _AnswerItemState extends State<AnswerItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _pressed = true;
          });

          if (kDebugMode) {
            print("ElevatedButton pressed, text: ${widget.answer.text}, isCorrect: ${widget.answer.isCorrect}");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _pressed ? (widget.answer.isCorrect ? Colors.green[100] : Colors.red[100]) : Colors.purple[100],
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        child: Text(widget.answer.text),
    );
  }
}



class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  Question question = const Question(
    text: "What is the time complexity of adding a node to the end of a linked list with a tail reference?",
    answers: [
      Answer(text: "O(1)", isCorrect: true),
      Answer(text: "O(log n)", isCorrect: false),
      Answer(text: "O(n)", isCorrect: false),
      Answer(text: "O(n!)", isCorrect: false),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuestionText(text: question.text),
          AnswerList(answers: question.answers),
        ],
    );
  }
}
