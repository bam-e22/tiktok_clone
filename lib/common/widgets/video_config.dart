import 'package:flutter/material.dart';

class VideoConfigData extends InheritedWidget {
  const VideoConfigData({
    super.key,
    required this.autoMute,
    required this.toggleMuted,
    required super.child,
  });

  final bool autoMute;
  final Function() toggleMuted;

  static VideoConfigData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class VideoConfig extends StatefulWidget {
  const VideoConfig({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  void _toggleMuted() {
    print("toggleMuted, $autoMute -> ${!autoMute}");
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      autoMute: autoMute,
      toggleMuted: _toggleMuted,
      child: widget.child,
    );
  }
}
