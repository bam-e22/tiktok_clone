import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  PlaybackConfigViewModel(
    this._repository,
  );

  final PlaybackConfigRepository _repository;

  Future<void> setMuted(bool value) async {
    await _repository.setMuted(value);
    state = state.copyWith(muted: value);
  }

  Future<void> setAutoplay(bool value) async {
    await _repository.setAutoplay(value);
    state = state.copyWith(autoplay: value);
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
        () => throw UnimplementedError());
