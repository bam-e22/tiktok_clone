import 'package:flutter/material.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class TwoLineTexts extends StatelessWidget {
  const TwoLineTexts({
    Key? key,
    required this.text,
    required this.subText,
  }) : super(key: key);

  final String text;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size16,
          ),
        ),
        Gaps.v3,
        Text(
          subText,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        )
      ],
    );
  }
}
