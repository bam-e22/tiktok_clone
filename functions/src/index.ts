import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

// listen firestore events 
export const onVideoCreated = functions.firestore
.document("videos/{videoId}")
.onCreate(async (snapshot, context) => {
    snapshot.ref.update({"hello": "from functions"});
});