import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoSnsButton extends StatelessWidget {
  const VideoSnsButton({
    Key? key,
    required this.icon,
    required this.text,
    this.enabled = false,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          icon,
          color: enabled ? Colors.red : Colors.white,
          size: Sizes.size40,
        ),
        Gaps.v5,
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
