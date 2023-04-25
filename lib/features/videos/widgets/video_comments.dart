import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import '../../../constants/gaps.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({Key? key}) : super(key: key);

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        title: Text(
          '22796 comments',
        ),
        actions: [
          IconButton(
            onPressed: _onClosePressed,
            icon: FaIcon(
              FontAwesomeIcons.xmark,
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          vertical: Sizes.size10,
          horizontal: Sizes.size16,
        ),
        itemCount: 10,
        separatorBuilder: (context, index) => Gaps.v20,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                child: Text("todd"),
              ),
              Gaps.h10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Sizes.size14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Gaps.v3,
                    Text(
                        "add showModelBottomSheet and apply annnn border radius."),
                  ],
                ),
              ),
              Gaps.h10,
              Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.heart,
                    size: Sizes.size20,
                    color: Colors.grey.shade500,
                  ),
                  Gaps.v2,
                  Text(
                    '52.2K',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade500,
              foregroundColor: Colors.white,
              child: Text("todd"),
            )
          ],
        ),
      ),
    );
  }
}
