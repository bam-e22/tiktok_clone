import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoTimelineScreen> createState() =>
      _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  int _itemCount = 0;

  void _onPageChanged(int page) {
    // TODO: 강제로 animate 하지 말고 pageView 스펙 자체를 변경할 수는 없을까?
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    // pagination
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).fetchNextPage();
    }
  }

  void _onVideoFinished() {
    return;
/*    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );*/
  }

  Future<void> _onRefresh() {
    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ref.watch(timelineProvider).when(
      loading: () {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      },
      error: (object, error) {
        print("timelineProvider error: $error");
        return const Center(
          child: Text(
            'Could not load videos',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
      data: (videos) {
        _itemCount = videos.length;
        return RefreshIndicator(
          displacement: 50,
          edgeOffset: 20,
          color: Theme.of(context).primaryColor,
          onRefresh: _onRefresh,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final videoData = videos[index];
              return VideoPost(
                onVideoFinished: _onVideoFinished,
                videoData: videoData,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
