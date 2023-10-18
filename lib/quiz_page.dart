import 'package:flutter/material.dart';
import 'services/openai_service.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  OpenAIService _service = OpenAIService();
  String _responseText = '';

  Future<String> _loadTranscriptAsset() async {
    return await rootBundle.loadString('lib/transcripts/example_transcript.txt');
  }

  void _getResponse() async {
    try {
      String transcript = await _loadTranscriptAsset();
      String prompt = "Following is a lecture transcript. \n \n Given this transcript, generate 5 multiple-choice questions and their correct answers. \n\n Answer with ONLY the questions, their correct answers, and their choices. For each question, write your response in the following format:\n\n1: Question text.\na) Option 1a b)\nOption 1b\nc) Option 1c\nd) Option 1d\nCORRECT: Option a\n\n Transcript: $transcript";

      String response = await _service.fetchResponse(
        prompt,
        maxTokens: 2000,
        temperature: 0.3,
        // other parameters...
      );

      setState(() {
        _responseText = response;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _getResponse,
            child: Text('Get Response from OpenAI'),
          ),
          Text(_responseText),
          QuestionView(),  // Removed Expanded widget here.
        ],
      ),
    );
  }
}

class QuestionView extends StatefulWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
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
            style: Theme.of(context).textTheme.headline4, // assuming `headlineLarge` was a typo.
          ),
        ),
      ] +
          List.generate(
              currentAnswerText.length,
                  (i) => Container(
                  padding: const EdgeInsets.all(50),
                  child: ElevatedButton(
                      onPressed: () => answerGuessed(i),
                      child: Text(currentAnswerText[i])))),
    );
  }
}