import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_mode_icon_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_record_button.dart';

import '../../constants/gaps.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
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

  void _startRecording() {
    print("start recording");
  }

  void _stopRecording() {
    print("stop recording");
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
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
                      ),
                      Positioned(
                        bottom: Sizes.size40,
                        child: VideoRecordButton(
                          startRecording: _startRecording,
                          stopRecording: _stopRecording,
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
