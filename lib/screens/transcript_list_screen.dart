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
          onTap: () => {
            // TODO: Add code to open quiz for transcript
          },
          title: Text(transcript.title),
          subtitle: Text(timeago.format(transcript.dateUploaded)),
          trailing: const Icon(Icons.play_arrow),
        ));
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
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return Stack(alignment: Alignment.bottomRight, children: [
              ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Container(
                      color: index % 2 == 0
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.01),
                      child: TranscriptListTile(
                          transcript: snapshot.data![index]))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingActionButton(
                  onPressed: () {
                    // TODO: Add code to upload transcript
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ]);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: [
                      Text(
                        'Welcome to Biscuitt, the AI study tool!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Upload your lecture transcript or notes to start generating unlimited practice questions.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => {
                          // TODO: Add code to upload transcript
                        },
                        child: const Text('Upload'),
                      ),
                    ]),
                  )
                ],
              ),
            );
          }
        });
  }
}
