import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/profile_edit_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tabbar.dart';
import 'package:tiktok_clone/features/users/views/widgets/two_line_texts.dart';
import 'package:tiktok_clone/features/videos/view_models/liked_video_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/my_video_view_model.dart';
import 'package:transparent_image/transparent_image.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _arrowAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  void _onYoutubeButtonTap() {
    print('_onYoutubeButtonTap');
  }

  void _onMoreButtonTap() {
    print('_onMoreButtonTap');
    _toggleAnimation();
  }

  void _toggleAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _onProfileEditPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileEditScreen(),
      ),
    );
  }

  void _onSettingPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (userProfile) {
            return Scaffold(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              body: SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(userProfile.name),
                          actions: [
                            IconButton(
                              onPressed: _onProfileEditPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.pen,
                                size: Sizes.size20,
                              ),
                            ),
                            IconButton(
                              onPressed: _onSettingPressed,
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
                              Gaps.v20,
                              Avatar(
                                name: userProfile.name,
                                uid: userProfile.uid,
                                isEditMode: false,
                                radius: 50,
                              ),
                              Gaps.v20,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '@${userProfile.name}',
                                    style: const TextStyle(
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
                              ),
                              Gaps.v14,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.33,
                                      child: Container(
                                        height: Sizes.size48,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            Sizes.size2,
                                          ),
                                        ),
                                        child: const Text(
                                          'Follow',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gaps.h4,
                                  Container(
                                    height: Sizes.size48,
                                    width: Sizes.size48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Sizes.size2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _onYoutubeButtonTap,
                                      icon: const FaIcon(
                                        FontAwesomeIcons.youtube,
                                        size: Sizes.size24,
                                      ),
                                    ),
                                  ),
                                  Gaps.h4,
                                  Container(
                                    height: Sizes.size48,
                                    width: Sizes.size48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Sizes.size2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _onMoreButtonTap,
                                      icon: RotationTransition(
                                        turns: _arrowAnimation,
                                        child: const FaIcon(
                                          FontAwesomeIcons.caretDown,
                                          size: Sizes.size18,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Gaps.v14,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size32,
                                ),
                                child: Text(
                                  userProfile.bio,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Gaps.v14,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.link,
                                    size: Sizes.size12,
                                  ),
                                  Gaps.h4,
                                  Text(
                                    userProfile.link,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Gaps.v20,
                            ],
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: PersistentTabBar(),
                          pinned: true,
                        )
                      ];
                    },
                    body: TabBarView(
                      children: [
                        ref.watch(myVideoProvider).when(
                              data: (thumbnails) {
                                return GridView.builder(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount: thumbnails.length,
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 9 / 14,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: Sizes.size2,
                                    mainAxisSpacing: Sizes.size2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 9 / 14,
                                          child: FadeInImage.memoryNetwork(
                                            fit: BoxFit.cover,
                                            placeholder: kTransparentImage,
                                            image:
                                                thumbnails[index].thumbnailUrl,
                                          ),
                                        ),
                                        const Positioned(
                                          bottom: 5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.play_arrow_outlined,
                                                color: Colors.white,
                                                size: Sizes.size24,
                                              ),
                                              Gaps.h2,
                                              Text(
                                                '4.1M',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Sizes.size14,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              error: (error, stackTrace) => Center(
                                child: Text(
                                  error.toString(),
                                ),
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                        ref.watch(likedVideoProvider).when(
                              data: (thumbnails) {
                                return GridView.builder(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount: thumbnails.length,
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 9 / 14,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: Sizes.size2,
                                    mainAxisSpacing: Sizes.size2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 9 / 14,
                                          child: FadeInImage.memoryNetwork(
                                            fit: BoxFit.cover,
                                            placeholder: kTransparentImage,
                                            image:
                                                thumbnails[index].thumbnailUrl,
                                          ),
                                        ),
                                        const Positioned(
                                          bottom: 5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.play_arrow_outlined,
                                                color: Colors.white,
                                                size: Sizes.size24,
                                              ),
                                              Gaps.h2,
                                              Text(
                                                '4.1M',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Sizes.size14,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              error: (error, stackTrace) => Center(
                                child: Text(
                                  error.toString(),
                                ),
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }
}
