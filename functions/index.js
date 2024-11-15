/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
const region = 'southamerica-east1'; // São Paulo region

admin.initializeApp();

exports.validatePassword = functions.region(region).https.onCall(async (data, context) => {
  // Get the password entered by the user
  const enteredPassword = data.password;
  
  // Fetch the stored password hash from Firestore
  const doc = await admin.firestore().collection("passwords").doc("unlockPassword").get();
  if (!doc.exists) {
    throw new functions.https.HttpsError('not-found', 'Password document not found');
  }

  const storedHash = doc.data().passwordHash;

  // Hash the entered password
  const hash = crypto.createHash("sha256").update(enteredPassword).digest("hex");

  // Compare the hashes
  if (hash === storedHash) {
    return { unlocked: true };
  } else {
    throw new functions.https.HttpsError('unauthenticated', 'Incorrect password');
  }
});