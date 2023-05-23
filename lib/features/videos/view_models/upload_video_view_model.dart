import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';
import 'package:tiktok_clone/router.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _videosRepository;

  @override
  FutureOr<void> build() {
    _videosRepository = ref.read(videosRepo);
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required File video,
    required String title,
    required String description,
  }) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        // storage
        final uploadTask =
            await _videosRepository.uploadVideo(video, user!.uid);
        if (uploadTask.metadata != null) {
          // database
          await _videosRepository.saveVideo(
            VideoModel(
              id: "", // TODO
              title: title,
              description: description,
              fileUrl: await uploadTask.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
              likes: 0,
              comments: 0,
            ),
          );
          context.pushReplacement("/${MainTabs.home.name}");
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
