import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/models/video_thumbnail_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class MyVideoViewModel extends AsyncNotifier<List<VideoThumbnailModel>> {
  late final VideosRepository _videosRepository;
  late final AuthenticationRepository _authRepository;
  List<VideoThumbnailModel> _list = [];

  @override
  FutureOr<List<VideoThumbnailModel>> build() async {
    _videosRepository = ref.read(videosRepo);
    _authRepository = ref.read(authRepo);
    _list = await _fetchMyVideos();
    return _list;
  }

  Future<List<VideoThumbnailModel>> _fetchMyVideos() async {
    final result =
        await _videosRepository.fetchMyVideos(_authRepository.user!.uid);
    final myVideos = result.docs
        .map(
          (doc) => VideoThumbnailModel.fromJson(
            json: doc.data(),
          ),
        )
        .toList();
    return myVideos;
  }
}

final myVideoProvider =
    AsyncNotifierProvider<MyVideoViewModel, List<VideoThumbnailModel>>(
  () => MyVideoViewModel(),
);
