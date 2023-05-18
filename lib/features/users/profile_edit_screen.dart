import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/profile_detail_edit_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/widgets/avatar.dart';
import 'package:tiktok_clone/utils.dart';

class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({
    Key? key,
  }) : super(key: key);

  void _onProfileInfoEditTap(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String key,
    required String value,
  }) async {
    final editedValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileDetailEditScreen(
          title: title,
          value: value,
        ),
      ),
    );
    if (editedValue != null && editedValue != value) {
      await ref
          .read(usersProvider.notifier)
          .updateUserProfile({key: editedValue});
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usersProvider).when(
        error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        data: (data) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.string.profileEditTitle),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Avatar(
                            uid: data.uid,
                            name: data.name,
                            hasAvatar: data.hasAvatar,
                            isEditMode: true,
                          ),
                          Gaps.v8,
                          Text(
                            context.string.changeAvatarHeader,
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ],
                      ),
                    ],
                  ),
                  Gaps.v32,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.size10),
                    child: Text(
                      context.string.userInfo,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ),
                  Gaps.v4,
                  ListTile(
                    title: Text(
                      context.string.nameHeader,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            data.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gaps.h12,
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: Sizes.size14,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      context.string.uidHeader,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            data.uid,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => _onProfileInfoEditTap(
                      context,
                      ref,
                      title: context.string.bioHeader,
                      key: "bio",
                      value: data.bio,
                    ),
                    title: Text(
                      context.string.bioHeader,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            data.bio,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gaps.h12,
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: Sizes.size14,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => _onProfileInfoEditTap(
                      context,
                      ref,
                      title: context.string.linkHeader,
                      key: "link",
                      value: data.link,
                    ),
                    title: Text(
                      context.string.linkHeader,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            data.link,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Gaps.h12,
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: Sizes.size14,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
