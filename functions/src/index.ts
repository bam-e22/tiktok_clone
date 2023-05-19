import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss", // seek
      "00:00:01.000",
      "-vframes", // pick 1 frame
      "1",
      "-vf", // video filter
      "scale=150:-1", // scale width=150, height=auto
      `/tmp/${snapshot.id}.jpg`,
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    const db = admin.firestore();
    await db
            .collection("users")
            .doc(video.creatorUid)
            .collection("videos")
            .doc(snapshot.id)
            .set({
                thumbnailUrl: file.publicUrl(),
                videoId: snapshot.id
            });
  });
