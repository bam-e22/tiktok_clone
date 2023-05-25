import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_like_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_sns_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
  });

  final Function onVideoFinished;
  final int index;
  final VideoModel videoData;

  @override
  ConsumerState<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  bool _isPaused = false;
  final Duration _animatedDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;
  bool _isTagTextExpanded = false;
  late bool _isMuted = ref.read(playbackConfigProvider).muted;
  late final bool _isLooping = ref.read(playbackConfigProvider).looping;
  late int likeCount = widget.videoData.likes;

  Future<void> _initVolume() async {
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    } else {
      await _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    }
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.network(widget.videoData.fileUrl);
    /*_videoPlayerController =
        VideoPlayerController.asset("assets/videos/39764.mp4"); // for test*/
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(_isLooping);
    _initVolume();

    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }

    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // make small
    } else {
      _videoPlayerController.play();
      _animationController.forward(); // make big
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _toggleMuted() {
    _isMuted = !_isMuted;
    _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    setState(() {});
  }

  void _toggleTagExpand() {
    setState(() {
      _isTagTextExpanded = !_isTagTextExpanded;
    });
  }

  void _onCommentTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
        context: context,
        builder: (context) => const VideoComments(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true
        // NOTE: BottomSheet shape 변경할 수 있는 또다른 방법
        /*clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.size16),
        ),
      ),*/
        );
    _onTogglePause();
  }

  void _onLikeTap() async {
    await ref
        .read(videoLikeProvider(widget.videoData.id).notifier)
        .toggleLikeVideo();
    final isSelfLiked =
        ref.read(videoLikeProvider(widget.videoData.id)).requireValue;
    if (isSelfLiked) {
      likeCount += 1;
    } else {
      likeCount -= 1;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animatedDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _videoPlayerController.value.size.height,
                width: _videoPlayerController.value.size.width,
                child: _videoPlayerController.value.isInitialized
                    ? VideoPlayer(_videoPlayerController)
                    : Image.network(
                        widget.videoData.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animatedDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${widget.videoData.creator}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Text(
                  widget.videoData.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v8,
                Text(
                  widget.videoData.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: Text(
                        '#flutter #dart #koltin #android #ios #mobile #dev',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w500,
                            overflow: _isTagTextExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis),
                      ),
                    ),
                    Visibility(
                      visible: !_isTagTextExpanded,
                      child: GestureDetector(
                        onTap: _toggleTagExpand,
                        child: const Text(
                          'See more',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: _isTagTextExpanded,
                  child: SizedBox(
                    width: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gaps.v5,
                        GestureDetector(
                          onTap: _toggleTagExpand,
                          child: const Text(
                            'Simply',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size16,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: FaIcon(
                _isMuted
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _toggleMuted,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-bam-e22.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media",
                  ),
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikeTap,
                  child: VideoSnsButton(
                    enabled: ref
                            .watch(videoLikeProvider(widget.videoData.id))
                            .value ??
                        false,
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(likeCount),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: VideoSnsButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                const VideoSnsButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
