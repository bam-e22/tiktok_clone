import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_timeline_screen.dart';
import 'package:tiktok_clone/router.dart';

import '../../../constants/gaps.dart';
import '../../../utils.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final String tab;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex = MainTabs.values.byName(widget.tab).index;

  void _onTap(int index) {
    context.go("/${MainTabs.values[index].name}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(Routes.videoRecordScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: Sizes.size32,
        ),
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                  text: 'Home',
                  isSelected: _selectedIndex == 0,
                  icon: FontAwesomeIcons.house,
                  selectedIcon: FontAwesomeIcons.house,
                  onTap: () => _onTap(0),
                  selectedIndex: _selectedIndex),
              NavTab(
                  text: 'Discover',
                  isSelected: _selectedIndex == 1,
                  icon: FontAwesomeIcons.compass,
                  selectedIcon: FontAwesomeIcons.solidCompass,
                  onTap: () => _onTap(1),
                  selectedIndex: _selectedIndex),
              Gaps.h24,
              PostVideoButton(
                onTap: _onPostVideoButtonTap,
                isInverted: _selectedIndex != 0,
              ),
              Gaps.h24,
              NavTab(
                  text: 'Inbox',
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.message,
                  selectedIcon: FontAwesomeIcons.solidMessage,
                  onTap: () => _onTap(3),
                  selectedIndex: _selectedIndex),
              NavTab(
                text: 'Profile',
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              )
            ],
          ),
        ),
      ),
    );
  }
}
