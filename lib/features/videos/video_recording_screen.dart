import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_mode_icon_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_record_button.dart';

import '../../constants/gaps.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late CameraController _cameraController;
  late FlashMode _flashMode;
  late double _maxZoomLevel;
  late double _minZoomLevel;
  late double _currentZoomLevel;
  final double _zoomStep = 0.05;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final isCameraPermissionGranted = cameraPermission.isGranted &&
        !(cameraPermission.isDenied || cameraPermission.isPermanentlyDenied);
    final isMicPermissionGranted = micPermission.isGranted &&
        !(micPermission.isDenied || micPermission.isPermanentlyDenied);

    if (isCameraPermissionGranted && isMicPermissionGranted && !_noCamera) {
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
    await _cameraController.prepareForVideoRecording(); // only for iOS
    _flashMode = _cameraController.value.flashMode;
    _maxZoomLevel = await _cameraController.getMaxZoomLevel();
    _minZoomLevel = await _cameraController.getMinZoomLevel();
    _currentZoomLevel = _minZoomLevel;
    print("max= $_maxZoomLevel, min= $_minZoomLevel");
    setState(() {});
  }

  Future<void> _startRecording() async {
    print("start recording");
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;
    print("stop recording");

    final video = await _cameraController.stopVideoRecording();
    print("video name: ${video.name}, path: ${video.path}");

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _setZoomLevel(LongPressMoveUpdateDetails details) async {
    if (details.offsetFromOrigin.direction < 0) {
      // upward
      _currentZoomLevel = min(_currentZoomLevel + _zoomStep, _maxZoomLevel);
    } else if (details.offsetFromOrigin.direction > 0) {
      // downward
      _currentZoomLevel = max(_currentZoomLevel - _zoomStep, _minZoomLevel);
    }
    await _cameraController.setZoomLevel(_currentZoomLevel);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
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
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            VideoRecordButton(
                              onTapDown: _startRecording,
                              onTapUp: _stopRecording,
                              onLongPressMoveUpdate: _setZoomLevel,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: _onPickVideoPressed,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : _noCamera
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          const Positioned(
                            child: Center(
                                child: Text(
                              "iOS Debug mode (no camera)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size20,
                              ),
                            )),
                          ),
                          Positioned(
                            bottom: Sizes.size40,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: _onPickVideoPressed,
                                      icon: const FaIcon(
                                        FontAwesomeIcons.image,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Camera error occurred",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size20,
                          ),
                        ),
                      ),
      ),
    );
  }
}
