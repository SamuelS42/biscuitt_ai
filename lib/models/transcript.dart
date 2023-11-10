class Transcript {
  final String id;
  final DateTime dateUploaded;
  final String title;
  final String text;

  Transcript(
      {required this.id,
      required this.dateUploaded,
      required this.title,
      required this.text});
}

class TranscriptListItem {
  final String id;
  final DateTime dateUploaded;
  final String title;
  final String blurb;

  TranscriptListItem(
      {required this.id,
      required this.dateUploaded,
      required this.title,
      required this.blurb});
}
