import 'package:biscuitt_ai/models/file_model.dart';
import 'package:biscuitt_ai/screens/file_upload_screen.dart';
import 'package:biscuitt_ai/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool _isQuizMode = false;

  void setQuizMode(bool isQuizMode) {
    setState(() {
      _isQuizMode = isQuizMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FileModel(),
      child: <Widget>[
        UploadScreen(
          setQuizMode: setQuizMode,
        ),
        const QuizScreen()
      ][_isQuizMode ? 1 : 0],
    );
  }
}
