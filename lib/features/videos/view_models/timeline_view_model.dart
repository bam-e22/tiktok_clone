import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

import '../models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _videosRepository;
  List<VideoModel> _list = []; // 복사본 유지. pagination 시 아이템 추가

  @override
  FutureOr<List<VideoModel>> build() async {
    _videosRepository = ref.read(videosRepo);
    final result = await _videosRepository.fetchVideos();
    final newList = result.docs.map(
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );
    _list = newList.toList();
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
