import 'package:flutter/foundation.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  PlaybackConfigViewModel(
    this._repository,
  );

  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;

  Future<void> setMuted(bool value) async {
    await _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  Future<void> setAutoplay(bool value) async {
    await _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
