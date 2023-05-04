import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';

class VideoRecordButton extends StatefulWidget {
  const VideoRecordButton({
    Key? key,
    required this.startRecording,
    required this.stopRecording,
  }) : super(key: key);

  final Function startRecording;
  final Function stopRecording;

  @override
  State<VideoRecordButton> createState() => _VideoRecordButtonState();
}

class _VideoRecordButtonState extends State<VideoRecordButton>
    with TickerProviderStateMixin {
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  void _onTapDown() {
    widget.startRecording();
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _onTapUp() {
    widget.stopRecording();
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  void initState() {
    super.initState();
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(),
      onTapUp: (details) => _onTapUp(),
      onLongPressEnd: (details) => _onTapUp(),
      child: ScaleTransition(
        scale: _buttonAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: Sizes.size94,
              height: Sizes.size94,
              child: AnimatedBuilder(
                animation: _progressAnimationController,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    color: Colors.red.shade400,
                    strokeWidth: Sizes.size6,
                    value: _progressAnimationController.value,
                  );
                },
                child: CircularProgressIndicator(
                  color: Colors.red.shade400,
                  strokeWidth: Sizes.size6,
                  value: 0,
                ),
              ),
            ),
            Container(
              width: Sizes.size80,
              height: Sizes.size80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
