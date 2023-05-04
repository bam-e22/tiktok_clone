import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import '../../constants/gaps.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late CameraController _cameraController;

  late FlashMode _flashMode;

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final isCameraPermissionGranted = cameraPermission.isGranted &&
        !(cameraPermission.isDenied || cameraPermission.isPermanentlyDenied);
    final isMicPermissionGranted = micPermission.isGranted &&
        !(micPermission.isDenied || micPermission.isPermanentlyDenied);

    if (isCameraPermissionGranted && isMicPermissionGranted) {
      _hasPermission = true;
      await initCamera();
    } else {
      _hasPermission = false;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : _hasPermission && _cameraController.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_cameraController),
                      Positioned(
                        top: Sizes.size72,
                        right: Sizes.size10,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: _toggleSelfieMode,
                              icon: const Icon(
                                Icons.cameraswitch,
                                size: Sizes.size40,
                              ),
                            ),
                            Gaps.v10,
                            FlashModeIconButton(
                              onTap: _setFlashMode,
                              flashMode: FlashMode.off,
                              enabled: _flashMode == FlashMode.off,
                            ),
                            Gaps.v10,
                            FlashModeIconButton(
                              onTap: _setFlashMode,
                              flashMode: FlashMode.always,
                              enabled: _flashMode == FlashMode.always,
                            ),
                            Gaps.v10,
                            FlashModeIconButton(
                              onTap: _setFlashMode,
                              flashMode: FlashMode.auto,
                              enabled: _flashMode == FlashMode.auto,
                            ),
                            Gaps.v10,
                            FlashModeIconButton(
                              onTap: _setFlashMode,
                              flashMode: FlashMode.torch,
                              enabled: _flashMode == FlashMode.torch,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      _hasPermission
                          ? "Permission denied"
                          : "Camera error occurred",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ),
      ),
    );
  }
}

extension on FlashMode {
  IconData getIcon() {
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
        flashMode.getIcon(),
        size: Sizes.size40,
      ),
    );
  }
}
