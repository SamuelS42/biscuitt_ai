import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum QuestionType { MultipleChoice, TrueFalse }

var SetQuestionType = 0;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  QuestionType? selectedQuestionType = QuestionType.MultipleChoice;

  void _showQuestionTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Question Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<QuestionType>(
                title: const Text('Multiple Choice'),
                value: QuestionType.MultipleChoice,
                groupValue: selectedQuestionType,
                onChanged: (QuestionType? value) {
                  setState(() {
                    selectedQuestionType = value;
                    SetQuestionType = 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<QuestionType>(
                title: const Text('True or False'),
                value: QuestionType.TrueFalse,
                groupValue: selectedQuestionType,
                onChanged: (QuestionType? value) {
                  setState(() {
                    selectedQuestionType = value;
                    SetQuestionType = 1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
                'Select your preferred question type before continuing!'),
            ListTile(
              title: const Text('Set Question Type'),
              subtitle: Text(selectedQuestionType == QuestionType.MultipleChoice
                  ? 'Multiple Choice'
                  : 'True or False'),
              onTap: _showQuestionTypeDialog,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/quiz'),
              child: const Text('Start Quiz!'),
            ),
          ],
        ),
      ),
    );
  }
}
