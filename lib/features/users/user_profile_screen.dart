import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/two_line_texts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('todd'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.gear,
                size: Sizes.size20,
              ),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/23008504?v=4',
                ),
                child: Text('todd'),
              ),
              Gaps.v20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '@todd',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size18,
                    ),
                  ),
                  Gaps.h4,
                  FaIcon(
                    FontAwesomeIcons.solidCircleCheck,
                    size: Sizes.size16,
                    color: Colors.blue.shade500,
                  ),
                ],
              ),
              Gaps.v24,
              SizedBox(
                height: Sizes.size48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TwoLineTexts(
                      text: '97',
                      subText: 'Following',
                    ),
                    VerticalDivider(
                      width: Sizes.size32,
                      thickness: Sizes.size1,
                      indent: Sizes.size14,
                      endIndent: Sizes.size14,
                      color: Colors.grey.shade400,
                    ),
                    const TwoLineTexts(
                      text: '10M',
                      subText: 'Followers',
                    ),
                    VerticalDivider(
                      width: Sizes.size32,
                      thickness: Sizes.size1,
                      indent: Sizes.size14,
                      endIndent: Sizes.size14,
                      color: Colors.grey.shade400,
                    ),
                    const TwoLineTexts(
                      text: '149.3M',
                      subText: 'Likes',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
