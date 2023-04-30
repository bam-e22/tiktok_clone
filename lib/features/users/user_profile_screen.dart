import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tabbar.dart';
import 'package:tiktok_clone/features/users/widgets/two_line_texts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size32,
                      ),
                      child: Text(
                        "I'm sharing daily development life. So exciting...... #Dart #Flutter #Android #Kotlin ",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size12,
                        ),
                        Gaps.h4,
                        Text(
                          'https://github.com/bam-e22',
                          style: TextStyle(
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
              GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              'https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80',
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
              const Center(
                child: Text('Page 2'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
