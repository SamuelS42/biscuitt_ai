import 'package:biscuitt_ai/models/transcript.dart';
import 'package:flutter/foundation.dart';

class TranscriptNotifier extends ChangeNotifier {
  Transcript _transcript = Transcript(
      id: '', dateUploaded: DateTime.timestamp(), title: '', text: '');

  set transcript(Transcript transcript) {
    _transcript = transcript;
    notifyListeners();
  }

  Transcript get transcript {
    return _transcript;
  }
}
