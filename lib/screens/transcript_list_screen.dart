import 'package:biscuitt_ai/models/transcript_model.dart';
import 'package:biscuitt_ai/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TranscriptListTile extends StatelessWidget {
  final TranscriptListItem transcript;

  const TranscriptListTile({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: ListTile(
            onTap: () => {},
            title: Text(transcript.title),
            subtitle: Text(timeago.format(transcript.dateUploaded))));
  }
}

class TranscriptListScreen extends StatefulWidget {
  const TranscriptListScreen({super.key});

  @override
  State<TranscriptListScreen> createState() => _TranscriptListScreenState();
}

class _TranscriptListScreenState extends State<TranscriptListScreen> {
  ApiService service = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TranscriptListItem>>(
        future: service.getTranscripts(),
        builder: (context, AsyncSnapshot<List<TranscriptListItem>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              children: <Widget>[
                for (var item in snapshot.data!)
                  TranscriptListTile(transcript: item),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
