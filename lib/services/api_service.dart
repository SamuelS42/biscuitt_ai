import 'package:flutter/services.dart';

import '../models/transcript_model.dart';

class ApiService {
  Future<List<TranscriptListItem>> getTranscripts() async {
    return [
      TranscriptListItem(
          id: "71be9b7b-16ad-49b4-b86e-87f41a88b4f9",
          dateUploaded: DateTime(2023, 11, 6, 12, 30, 45),
          title: "Data Structures and Dynamic Arrays",
          blurb: "Welcome to 006, Introduction to Algorithms, lecture two."),
      TranscriptListItem(
          id: "1c05f9f3-da6c-4163-9781-bf7c64aed5af",
          dateUploaded: DateTime(2023, 11, 5, 20, 14, 23),
          title: "Gestalt Principles",
          blurb:
              "Okay, in terms of accidental creation, I think that these gestalt principles actually at times do pop up a bit more"),
      TranscriptListItem(
          id: "908d0baa-f609-482b-a028-8657b7c1164b",
          dateUploaded: DateTime(2023, 11, 3, 50, 2, 0),
          title: "Calculus Introduction to Limits",
          blurb:
              "So let's start right away with stuff that we will need to see before we can go on to more advanced things."),
    ];
  }

  Future<Transcript> getTranscript(String id) async {
    if (id == "71be9b7b-16ad-49b4-b86e-87f41a88b4f9") {
      return Transcript(
          id: "71be9b7b-16ad-49b4-b86e-87f41a88b4f9",
          dateUploaded: DateTime(2023, 11, 6, 12, 30, 45),
          title: "Data Structures and Dynamic Arrays",
          text: await rootBundle
              .loadString("lib/transcripts/data_structures_transcript.txt"));
    } else if (id == "1c05f9f3-da6c-4163-9781-bf7c64aed5af") {
      return Transcript(
          id: "1c05f9f3-da6c-4163-9781-bf7c64aed5af",
          dateUploaded: DateTime(2023, 11, 5, 20, 14, 23),
          title: "Gestalt Principles",
          text: await rootBundle
              .loadString("lib/transcripts/gestalt_principles_transcript.txt"));
    } else if (id == "908d0baa-f609-482b-a028-8657b7c1164b") {
      return Transcript(
          id: "908d0baa-f609-482b-a028-8657b7c1164b",
          dateUploaded: DateTime(2023, 11, 3, 50, 2, 0),
          title: "Calculus Introduction to Limits",
          text: await rootBundle
              .loadString("lib/transcripts/calculus_limits_transcript.txt"));
    } else {
      throw Exception("Transcript does not exist.");
    }
  }
}
