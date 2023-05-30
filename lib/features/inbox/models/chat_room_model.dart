class ChatRoomModel {
  ChatRoomModel({
    required this.chatRoomId,
    required this.createdAt,
    required this.otherUid,
    required this.otherName,
    required this.lastMessage,
  });

  final String chatRoomId;
  final int createdAt;
  final String otherUid;
  final String otherName;
  final String lastMessage;
}
