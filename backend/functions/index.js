/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const express = require("express");

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");

initializeApp();

const app = express();

app.post("/users/:userId/transcripts", async (req, res) => {
  const writeResult = await getFirestore()
      .collection("transcripts")
      .add({
        userId: req.params.userId,
        filename: req.body.filename,
        dateUploaded: Timestamp.fromDate(new Date()),
        text: req.body.text,
      });
  res.json({id: writeResult.id});
});

// Expose Express API as a single Cloud Function:
exports.api = onRequest(app);
