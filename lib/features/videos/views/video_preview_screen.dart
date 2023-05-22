import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({
    Key? key,
    required this.video,
    required this.isPicked,
  }) : super(key: key);

  final XFile video;
  final bool isPicked;

  @override
  ConsumerState<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  bool _savedVideo = false;

  late final TextEditingController _titleController =
      TextEditingController(text: "");

  late final TextEditingController _descriptionController =
      TextEditingController(text: "");

  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  void _saveToGallery() async {
    if (_savedVideo) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: "TikTok Clone");
    _savedVideo = true;
    setState(() {});
  }

  void _onUploadPressed(BuildContext context) {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          context: context,
          video: File(widget.video.path),
          title: _titleController.text,
          description: _descriptionController.text,
        );
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview video'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading
                ? null
                : () => {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: Sizes.size20,
                              right: Sizes.size20,
                              top: Sizes.size32,
                              bottom: Sizes.size32,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "title",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.grey.shade700,
                                      ),
                                ),
                                TextField(
                                  controller: _titleController,
                                  maxLines: 1,
                                  maxLength: 20,
                                ),
                                Gaps.v12,
                                Text(
                                  "description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.grey.shade700,
                                      ),
                                ),
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 5,
                                  maxLength: 100,
                                ),
                                Gaps.v20,
                                Text(
                                  "불법 촬영 콘텐츠를 업로드하면 법률에 따라 처벌되고 삭제될 수 있습니다.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.grey.shade700,
                                        fontSize: Sizes.size12,
                                      ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FractionallySizedBox(
                                        widthFactor: 1,
                                        child: OutlinedButton(
                                          onPressed: () => {},
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Sizes.size1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  fontSize: Sizes.size16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.h8,
                                    Expanded(
                                      child: FractionallySizedBox(
                                        widthFactor: 1,
                                        child: FilledButton.tonal(
                                          onPressed: () =>
                                              _onUploadPressed(context),
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Sizes.size1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'upload',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  fontSize: Sizes.size16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                    },
            icon: ref.watch(uploadVideoProvider).isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                : const FaIcon(
                    FontAwesomeIcons.cloudArrowUp,
                  ),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? SafeArea(
              child: VideoPlayer(_videoPlayerController),
            )
          : null,
    );
  }
}
