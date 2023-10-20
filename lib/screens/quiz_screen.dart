import 'dart:async';
import 'dart:io';

import 'package:biscuitt_ai/models/file_model.dart';
import 'package:biscuitt_ai/models/question_model.dart';
import 'package:biscuitt_ai/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/score_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();

    String uploadedFilePath = '';

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      uploadedFilePath = context.read<FileModel>().uploadedFilePath;
      _loadTranscriptAsset(uploadedFilePath).then((text) {
        _getResponse(text);
      });
    });
  }

  final OpenAIService _service = OpenAIService();
  String _responseText = '';
  List<Question> _questions = [];

  Future<String> _loadTranscriptAsset(String filePath) async {
    try {
      final file = File(filePath);

      // Read the file
      return await file.readAsString();
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  List<Question> parseQuestions(String responseText) {
    var lines = responseText.split("\n");
    List<Question> questions = [];

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(RegExp(r'^\d+\:'))) {
        String questionText =
            lines[i].substring(lines[i].indexOf(':') + 1).trim();
        List<Answer> answers = [];
        int correctIndex = -1;

        while (i + 1 < lines.length &&
            (lines[i + 1].contains(RegExp(r'^[a-d]\)')) ||
                lines[i + 1].startsWith("CORRECT: Option "))) {
          i++;

          if (lines[i].startsWith("CORRECT: Option ")) {
            correctIndex = "abcd".indexOf(lines[i][16]);
          } else {
            String answerText = lines[i].substring(3).trim();
            answers.add(Answer(
                text: answerText,
                isCorrect: false)); // Temporarily set isCorrect to false
          }
        }

        if (correctIndex != -1 && correctIndex < answers.length) {
          answers[correctIndex].isCorrect =
              true; // Set the correct answer after parsing all options
        }

        questions.add(Question(text: questionText, answers: answers));
      }
    }

    return questions;
  }

  void _getResponse(String transcript) async {
    try {
      // print('Starting _getResponse');
      // print('Loaded transcript');
      String prompt =
          "Following is a lecture transcript. \n \n Given this transcript, generate 5 multiple-choice questions and their correct answers. \n\n Answer with ONLY the questions, their correct answers, and their choices. For each question, write your response in the following format:\n\n1: Question text.\na) Option 1a b)\nOption 1b\nc) Option 1c\nd) Option 1d\nCORRECT: Option a\n\n Transcript: $transcript";
      String response = await _service.fetchResponse(
        prompt,
        maxTokens: 2000,
        temperature: 0.3,
      );
      // print('response fetched');

      setState(() {
        _responseText = response;
        // print(_responseText);
        _questions = parseQuestions(_responseText);
        // for (var i = 0; i < _questions.length; i++) {
        //   print('Q$i');
        //   for (var j = 0; j < _questions[i].answers.length; j++) {
        //     print(_questions[i].answers[j].isCorrect);
        //   }
        // }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ScoreModel(),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ScoreText(),
                  const SizedBox(height: 32),
                  ListView.separated(
                    separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) =>
                        QuestionView(question: _questions[index]),
                  ),
                ],
              ),
            )));
  }
}

class ScoreText extends StatelessWidget {
  const ScoreText({super.key});

  @override
  Widget build(BuildContext context) {
    var score = context.watch<ScoreModel>();
    return Text(
      "Score: ${score.score}",
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class QuestionText extends StatelessWidget {
  const QuestionText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headlineSmall,
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
  const AnswerItem({required this.answer, super.key});

  final Answer answer;

  @override
  State<AnswerItem> createState() => _AnswerItemState();
}

class _AnswerItemState extends State<AnswerItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    var score = context.watch<ScoreModel>();

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _pressed = true;
        });

        if (widget.answer.isCorrect) {
          score.addToScore(1);
        }

        debugPrint(
            "ElevatedButton pressed, text: ${widget.answer.text}, isCorrect: ${widget.answer.isCorrect}");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _pressed
            ? (widget.answer.isCorrect ? Colors.green[100] : Colors.red[100])
            : Theme.of(context).buttonTheme.colorScheme?.background,
      ),
      child: Text(widget.answer.text),
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
        const SizedBox(height: 20),
        AnswerList(answers: widget.question.answers),
      ],
    );
  }
}
