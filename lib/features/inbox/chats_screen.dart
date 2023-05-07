import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/router.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  final List<int> _items = [];

  final Duration _duration = const Duration(milliseconds: 300);

  void _addItem() {
    _key.currentState?.insertItem(
      _items.length,
      duration: _duration,
    );
    _items.add(_items.length);
  }

  void _deleteItem(int index) {
    _key.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _makeTile(index),
      ),
      duration: _duration,
    );
    _items.removeAt(index);
  }

  void _onChatTap(int index) {
    context.pushNamed(
      Routes.chatDetailScreen,
      pathParameters: {"chatId": "$index"},
    );
  }

  Widget _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/23008504?v=4'),
        child: Text('todd'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            key: UniqueKey(),
            'ddonggo $index',
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
      subtitle: const Text(
        'last message',
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
      body: AnimatedList(
        key: _key,
        initialItemCount: 0,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, Animation<double> animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
