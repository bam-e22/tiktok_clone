import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class ProfileDetailEditScreen extends ConsumerWidget {
  ProfileDetailEditScreen({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;
  late final TextEditingController _controller =
      TextEditingController(text: value);

  void _onCompletePressed(BuildContext context) {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => _onCompletePressed(context),
            child: Text(
              context.string.complete,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                maxLines: 10,
                maxLength: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
