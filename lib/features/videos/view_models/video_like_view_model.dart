import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoLikeViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepository _videosRepository;
  late final String _videoId;
  late bool _isLiked;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _videosRepository = ref.read(videosRepo);
    final user = ref.read(authRepo).user;
    _isLiked = await _videosRepository.isLikedVideo(
        videoId: _videoId, userId: user!.uid);
    return _isLiked;
  }

  Future<void> toggleLikeVideo() async {
    final user = ref.read(authRepo).user;
    await _videosRepository.toggleLikeVideo(
      videoId: _videoId,
      userId: user!.uid,
    );
    _isLiked = !_isLiked;
    state = AsyncValue.data(_isLiked);
  }
}

final videoLikeProvider =
    AsyncNotifierProvider.family<VideoLikeViewModel, bool, String>(
  () => VideoLikeViewModel(),
);
