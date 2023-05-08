import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';

class FlashModeIconButton extends StatelessWidget {
  const FlashModeIconButton({
    Key? key,
    required this.flashMode,
    required this.onTap,
    required this.enabled,
  }) : super(key: key);

  final FlashMode flashMode;
  final Function(FlashMode) onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: enabled ? Colors.amber.shade200 : Colors.white,
      onPressed: () => onTap(flashMode),
      icon: Icon(
        flashMode._getIcon(),
        size: Sizes.size40,
      ),
    );
  }
}

extension on FlashMode {
  IconData _getIcon() {
    switch (this) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.torch:
        return Icons.flashlight_on_rounded;
    }
  }
}
