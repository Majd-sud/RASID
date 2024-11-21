/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const { onRequest } = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//     logger.info("Hello logs!", { structuredData: true });
//     response.send("Hello from Firebase!");
// });


// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";

// admin.initializeApp();

// exports.copyFileToViolationImages = functions.storage.object().onFinalize(async (object) => {
//     const bucket = admin.storage().bucket();
//     const filePath = object.name; // Original path of the file
//     const fileName = filePath.split('/').pop(); // Name of the file
//     const newFilePath = `violation_images/${fileName}`; // New path for the copied file

//     // Check if the file is located in the original path (adjust the condition as needed)
//     if (filePath.startsWith('gs://rasid-cam.appspot.com')) { // Specify your original path here
//         try {
//             await bucket.file(filePath).copy(bucket.file(newFilePath));
//             console.log(`Copied: ${filePath} to ${newFilePath}`);
//         } catch (error) {
//             console.error(`Failed to copy: ${error}`);
//         }
//     } else {
//         console.log(`File does not match condition: ${filePath}`);
//     }
// });

// //  code run: firebase deploy --only functions