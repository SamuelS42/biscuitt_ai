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

const db = getFirestore();
const usersRef = db.collection("users");
const transcriptsRef = db.collection("transcripts");

const USERS_ENDPOINT = "/users";
const TRANSCRIPTS_ENDPOINT = `${USERS_ENDPOINT}/:userId/transcripts`;

const app = express();

// users endpoints
app.post(USERS_ENDPOINT, async (req, res, next) => {
  const docRef = await usersRef.add({
    username: req.body.username,
  });
  res.status(201).json({id: docRef.id});
});

app.put(`${USERS_ENDPOINT}/:id`, async (req, res, next) => {
  const docRef = await usersRef.add({
    id: req.params.id,
    username: req.body.username,
  });
  res.json({id: docRef.id});
});

app.get(`${USERS_ENDPOINT}/:id`, async (req, res, next) => {
  const user = await usersRef.doc(req.params.id).data();
  res.json(user);
});

app.delete(`${USERS_ENDPOINT}/:id`, async (req, res, next) => {
  await usersRef.doc(req.params.id).delete();
  res.sendStatus(200);
});

// transcripts endpoints
app.post(TRANSCRIPTS_ENDPOINT, async (req, res, next) => {
  const docRef = await transcriptsRef.add({
    userId: req.params.userId,
    filename: req.body.filename,
    dateUploaded: Timestamp.fromDate(new Date()),
    text: req.body.text,
  });
  res.json({id: docRef.id});
});

app.get(TRANSCRIPTS_ENDPOINT, async (req, res, next) => {
  const snapshot = await transcriptsRef.where("userId", "==", req.params.userId)
      .get();

  const data = [];
  snapshot.forEach((doc) => {
    data.push({id: doc.id, ...doc.data()});
  });
  res.json(data);
});

app.get(`${TRANSCRIPTS_ENDPOINT}/:transcriptId`, async (req, res, next) => {
  await transcriptsRef.doc(req.params.transcriptId).delete();
  res.sendStatus(200);
});

// Expose Express API as a single Cloud Function:
exports.api = onRequest(app);
