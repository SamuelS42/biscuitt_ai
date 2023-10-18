import 'package:flutter/foundation.dart';

class ScoreModel extends ChangeNotifier {
  int _score = 0;

  void addToScore(int value) {
    _score += value;
    notifyListeners();
  }

  int getScore() {
    return _score;
  }
}