import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatefulWidget {
  const PostVideoButton({
    Key? key,
    required this.onTap,
    required this.isInverted,
  }) : super(key: key);

  final bool isInverted;
  final Function onTap;

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  double _scale = 1.0;

  void onTapDown() {
    setState(() {
      _scale = 1.2;
    });
  }

  void onTapUp() {
    widget.onTap();
    setState(() {
      _scale = 1.0;
    });
  }

  void onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return GestureDetector(
      onTapUp: (detail) => onTapUp(),
      onTapDown: (detail) => onTapDown(),
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 20,
              child: Container(
                height: 35,
                width: 25,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff61D4F0),
                  borderRadius: BorderRadius.circular(
                    Sizes.size8,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              child: Container(
                height: 35,
                width: 25,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(
                    Sizes.size8,
                  ),
                ),
              ),
            ),
            Container(
              height: 35,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              decoration: BoxDecoration(
                  color: !widget.isInverted || isDark
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(Sizes.size6)),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: !widget.isInverted || isDark
                      ? Colors.black
                      : Colors.white,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
