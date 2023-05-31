import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatRoom({
    required String chatRoomId,
    required String uid,
    required String otherUid,
  }) async {
    final query = _db.collection("chat_rooms").doc(chatRoomId);
    final chatRoom = await query.get();
    if (!chatRoom.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "personA": uid,
        "personB": otherUid,
      });
    }
  }

  // TODO: delete via cloud functions
  Future<void> deleteChatRoom({
    required String chatRoomId,
  }) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("text")
        .get()
        .then(
          (querySnapshot) => querySnapshot.docs.forEach(
            (doc) {
              doc.reference.delete();
            },
          ),
        );
    await _db.collection("chat_rooms").doc(chatRoomId).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms(String uid) async {
    final chatRoomsQuery =
        _db.collection("users").doc(uid).collection("chat_rooms");
    return await chatRoomsQuery.get();
  }

  Future<String> getUserName(String uid) async {
    final query = _db.collection("users").doc(uid);
    final user = await query.get();
    return user.data()?["name"] ?? "";
  }
}

final chatRoomRepo = Provider(
  (ref) => ChatRoomRepository(),
);
