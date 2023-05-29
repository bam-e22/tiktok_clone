import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_users_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';

class ChatUsersScreen extends ConsumerWidget {
  const ChatUsersScreen({
    Key? key,
  }) : super(key: key);

  Future<void> _onUserTap(
    BuildContext context,
    WidgetRef ref,
    UserProfileModel user,
  ) async {
    await ref
        .read(chatRoomProvider.notifier)
        .createChatRoom(context: context, otherUid: user.uid);
  }

  Widget _makeTile(
    BuildContext context,
    WidgetRef ref,
    UserProfileModel user,
  ) {
    return ListTile(
      onTap: () => _onUserTap(context, ref, user),
      leading: Avatar(
        radius: 30,
        uid: user.uid,
        name: user.name,
      ),
      title: Text(
        key: UniqueKey(),
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        user.uid,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Users'),
      ),
      body: ref.watch(chatUsersProvider).when(
            data: (users) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return _makeTile(context, ref, users[index]);
                },
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: users.length,
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
