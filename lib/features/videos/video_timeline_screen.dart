import 'dart:math';

import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({Key? key}) : super(key: key);

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;
  final PageController _pageController = PageController();
  final List<Color> _colors = [
    Colors.blue,
    Colors.teal,
    Colors.yellow,
    Colors.amber
  ];

  void _onPageChanged(int page) {
    // TODO: 강제로 animate 하지 말고 pageView 스펙 자체를 변경할 수는 없을까?
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );

    var moreItemCount = 4;
    if (page == _itemCount - 1) {
      for (var i = 0; i < moreItemCount; i++) {
        _colors.add(
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
      }
      setState(() {
        _itemCount += moreItemCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _itemCount,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) => Container(
        color: _colors[index],
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}
