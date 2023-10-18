import 'package:biscuitt_ai/models/question_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:biscuitt_ai/services/openai_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreen();
}

class _QuizScreen extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    _getResponse();
  }

  final OpenAIService _service = OpenAIService();
  String _responseText = '';
  List<Question> _questions = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) => QuestionView(question: _questions[index]),
      ),
    );
  }

  Future<String> _loadTranscriptAsset() async {
    return await rootBundle.loadString('lib/transcripts/example_transcript.txt');
  }

  void _getResponse() async {
    try {
      print('Starting _getResponse');
      String transcript = await _loadTranscriptAsset();
      print('Loaded transcript');
      String prompt = "Following is a lecture transcript. \n \n Given this transcript, generate 5 multiple-choice questions and their correct answers. \n\n Answer with ONLY the questions, their correct answers, and their choices. For each question, write your response in the following format:\n\n1: Question text.\na) Option 1a b)\nOption 1b\nc) Option 1c\nd) Option 1d\nCORRECT: Option a\n\n Transcript: $transcript";
      String response = await _service.fetchResponse(
        prompt,
        maxTokens: 2000,
        temperature: 0.3,
      );
      print('response fetched');

      setState(() {
        _responseText = response;
        // print(_responseText);
        _questions = parseQuestions(_responseText); // parse and store in a variable
        print('Parsed Questions: ${_questions.length}');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<Question> parseQuestions(String responseText) {
    var lines = responseText.split("\n");
    List<Question> questions = [];

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(RegExp(r'^\d+\:'))) {
        String questionText = lines[i].substring(lines[i].indexOf(':') + 1).trim();
        List<Answer> answers = [];  // Using List<Answer> instead of List<String>
        int correctIndex = -1;

        while (i + 1 < lines.length && lines[i + 1].contains(RegExp(r'^[a-d]\)'))) {
          i++;
          String answerText = lines[i].substring(3).trim();

          if (i + 1 < lines.length && lines[i + 1].startsWith("CORRECT: Option")) {
            correctIndex = "abcd".indexOf(lines[i + 1][15]);
            i++;
          }

          // Create the Answer object and mark it as correct if it's the correct answer
          answers.add(Answer(text: answerText, isCorrect: answers.length == correctIndex));
        }

        questions.add(Question(text: questionText, answers: answers));
      }
    }

    return questions;
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

class AnswerItem extends StatelessWidget {
  AnswerItem({
    required this.answer,
  }) : super(key: ObjectKey(answer));

  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (kDebugMode) {
          print("ElevatedButton pressed, text: ${answer
              .text}, isCorrect: ${answer.isCorrect}");
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(answer.text),
    );
  }
}

class QuestionView extends StatefulWidget {
  final Question question;
  const QuestionView({required this.question, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionView();
}

class _QuestionView extends State<QuestionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuestionText(text: widget.question.text),
        AnswerList(answers: widget.question.answers),
      ],
    );
  }
}