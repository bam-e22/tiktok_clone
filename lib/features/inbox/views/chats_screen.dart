import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_users_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/router.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatUsersScreen(),
      ),
    );
  }

  Future<void> _onChatLongPressed(String chatRoomId) async {
    await ref
        .read(chatRoomProvider.notifier)
        .deleteChatRoom(chatRoomId: chatRoomId);
  }

  void _onChatTap(String chatRoomId) {
    context.pushNamed(
      Routes.chatDetailScreen,
      pathParameters: {"chatRoomId": chatRoomId},
    );
  }

  Widget _makeTile(ChatRoomModel chatRoom) {
    return ListTile(
      onLongPress: () => _onChatLongPressed(chatRoom.chatRoomId),
      onTap: () => _onChatTap(chatRoom.chatRoomId),
      leading: Avatar(
        radius: 30,
        name: chatRoom.otherName,
        uid: chatRoom.otherUid,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            key: UniqueKey(),
            chatRoom.otherName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '2:16 PM',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: Text(
        "현재 접속 중",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          )
        ],
      ),
      body: ref.watch(chatRoomProvider).when(
            data: (chatRooms) {
              return ListView.separated(
                itemBuilder: (context, index) => _makeTile(chatRooms[index]),
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: chatRooms.length,
              );
            },
            error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
    );
  }
}
