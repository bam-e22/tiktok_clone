import 'package:flutter/foundation.dart';

@immutable
class PlaybackConfigModel {
  const PlaybackConfigModel({
    required this.muted,
    required this.autoplay,
  });

  final bool muted;
  final bool autoplay;

  PlaybackConfigModel copyWith({bool? muted, bool? autoplay}) {
    return PlaybackConfigModel(
      muted: muted ?? this.muted,
      autoplay: autoplay ?? this.autoplay,
    );
  }
}
