import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_sns_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
  }) : super(key: key);

  final Function onVideoFinished;
  final int index;

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/IMG_6292.MOV");

  bool _isPaused = false;
  final Duration _animatedDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;
  bool _isTagTextExpanded = false;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      final autoplay = context.read<PlaybackConfigViewModel>().autoplay;
      if (autoplay) {
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

    context
        .read<PlaybackConfigViewModel>()
        .addListener(_onPlaybackConfigChanged);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    context
        .read<PlaybackConfigViewModel>()
        .removeListener(_onPlaybackConfigChanged);
    super.dispose();
  }

  void _onPlaybackConfigChanged() {
    final muted = context.read<PlaybackConfigViewModel>().muted;
    if (muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
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
                const Text(
                  '@todd',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                const Text(
                  'Hi Hi Hi',
                  style: TextStyle(
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
                context.watch<PlaybackConfigViewModel>().muted
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: () {
                context
                    .read<PlaybackConfigViewModel>()
                    .setMuted(!context.read<PlaybackConfigViewModel>().muted);
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/23008504?v=4'),
                  child: Text('todd'),
                ),
                Gaps.v24,
                VideoSnsButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(8787324),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: VideoSnsButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(432500000),
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
