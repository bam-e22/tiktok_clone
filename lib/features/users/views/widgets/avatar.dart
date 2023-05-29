import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerStatefulWidget {
  Avatar({
    super.key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
    required this.isEditMode,
  });

  final String name;
  final bool hasAvatar;
  final String uid;
  final bool isEditMode;
  late final String avatarUrl =
      "https://firebasestorage.googleapis.com/v0/b/tiktok-bam-e22.appspot.com/o/avatars%2F$uid?alt=media";

  @override
  ConsumerState createState() => _AvatarState();
}

class _AvatarState extends ConsumerState<Avatar> {
  DateTime timestamp = DateTime.timestamp();

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final XFile? xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    if (xFile != null) {
      final file = File(xFile.path);
      await ref.read(avatarProvider.notifier).uploadAvatar(file);
      await CachedNetworkImage.evictFromCache(widget.avatarUrl);
      setState(() {
        timestamp = DateTime.timestamp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: widget.hasAvatar
          ? CachedNetworkImage(
              key: ValueKey(timestamp),
              imageUrl: widget.avatarUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black26,
                          BlendMode.overlay,
                        )),
                  ),
                  child: widget.isEditMode
                      ? Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: Sizes.size32,
                            color: Colors.white,
                          ),
                        )
                      : null,
                );
              },
            )
          : CircleAvatar(
              radius: 50,
              child: Text(widget.name),
            ),
    );
  }
}
