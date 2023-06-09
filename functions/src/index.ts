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
        "thumbnailUrl": file.publicUrl(),
        "videoId": snapshot.id
      });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    const videoDocRef = db.collection("videos").doc(videoId);

    await videoDocRef
      .update({
        likes: admin.firestore.FieldValue.increment(1),
      });

    const videoDoc = await videoDocRef.get();
    const video = videoDoc.data();

    if (video) {
      await db
        .collection("users")
        .doc(userId)
        .collection("likes")
        .doc(videoId)
        .set({
          "thumbnailUrl": video.thumbnailUrl,
          "videoId": videoId
        });

        // send message to video creator
        const creatorUid = video.creatorUid;
        const videoCreator = await(await db.collection("users").doc(creatorUid).get()).data();
        if (videoCreator) {
            const token = videoCreator.token;
            admin.messaging().sendToDevice(token, {
                data: {
                    screen: "123",
                },
                notification: {
                    title: "someone liked you video",
                    body: "Likes + 1! Congrats!"
                }
            })
        }
    }
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(-1),
      });

    await db.collection("users").doc(userId).collection("likes").doc(videoId).delete();
  });

export const onChatRoomCreated = functions.firestore
  .document("chat_rooms/{chatRoomId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const chatRoom = snapshot.data();

    await db
      .collection("users")
      .doc(chatRoom.personA)
      .collection("chat_rooms")
      .doc(snapshot.id)
      .set({ "personA": chatRoom.personA, "personB": chatRoom.personB, "createdAt": chatRoom.createdAt });

    await db
      .collection("users")
      .doc(chatRoom.personB)
      .collection("chat_rooms")
      .doc(snapshot.id)
      .set({ "personA": chatRoom.personB, "personB": chatRoom.personA, "createdAt": chatRoom.createdAt });
  });

export const onChatRoomRemoved = functions.firestore
  .document("chat_rooms/{chatRoomId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const chatRoom = snapshot.data();

    await db
      .collection("users")
      .doc(chatRoom.personA)
      .collection("chat_rooms")
      .doc(snapshot.id)
      .delete();

    await db
      .collection("users")
      .doc(chatRoom.personB)
      .collection("chat_rooms")
      .doc(snapshot.id)
      .delete();
  });
