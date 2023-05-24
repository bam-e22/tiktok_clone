import 'package:flutter/foundation.dart';

@immutable
class PlaybackConfigModel {
  const PlaybackConfigModel({
    required this.muted,
    required this.autoplay,
    required this.looping,
  });

  final bool muted;
  final bool autoplay;
  final bool looping;

  PlaybackConfigModel copyWith({bool? muted, bool? autoplay, bool? looping}) {
    return PlaybackConfigModel(
      muted: muted ?? this.muted,
      autoplay: autoplay ?? this.autoplay,
      looping: looping ?? this.looping,
    );
  }
}
