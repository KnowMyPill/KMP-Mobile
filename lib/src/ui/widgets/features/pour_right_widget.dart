import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../app/global_audio_player.dart';
import '../../../core/pillkaboo_util.dart';
import 'dart:core';
//import '../../../utils/liquid_volume_estimator.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class PourRightWidget extends StatefulWidget {
  final StreamController<bool> controller;

  const PourRightWidget({
    Key? key,
    this.width,
    this.height,
    required this.controller,
  }) : super(key: key);
  final double? width;
  final double? height;
  @override
  State<PourRightWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<PourRightWidget> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  Timer? _pictureTimer;
  int _currentCC = 0;

  //LiquidVolumeEstimator liquidVolumeEstimator = LiquidVolumeEstimator();

  @override
  void initState() {
    super.initState();
    GlobalAudioPlayer().playRepeat();
    _initialize();
  }

  double calculatePlaybackRate(double currentCC, double pourAmount) {
    const double maxRate = 2.0; // Maximum playback rate
    const double minRate = 1.0; // Normal playback rate

    if (_currentCC >= pourAmount || pourAmount == 0) return minRate;

    // Calculate the rate based on how close currentCC is to pourAmount
    double rate = minRate + (maxRate - minRate) * (currentCC / pourAmount);

    return rate.clamp(
        minRate, maxRate); // Ensure the rate is within [minRate, maxRate]
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == CameraLensDirection.back) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _pictureTimer?.cancel();
    GlobalAudioPlayer().pause();
    _stopLiveFeed();
    //liquidVolumeEstimator.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentCC >= PKBAppState().pourAmount) {
        _currentCC = 0;
        GlobalAudioPlayer().pause();
        widget.controller.add(true);
      }
    });
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CameraPreview(
                    _controller!,
                    child: null,
                  ),
          ),
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _pictureTimer =
          Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _takePicture();
      });
      setState(() {});
    });
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      // Check if the controller is initialized
      debugPrint("Controller is not initialized");
      return;
    }
    if (_controller!.value.isTakingPicture) {
      // If a capture is already pending, do not take another
      return;
    }
    try {
      final picture = await _controller!.takePicture();
      await _analyzePicture(picture);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _analyzePicture(XFile picture) async {
    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      "${DateTime.now()}.jpg",
    );
    await picture.saveTo(path);

    final req = http.MultipartRequest(
        "POST", Uri.parse("http://pill.m3sigma.net:3000/"));
    final image = await http.MultipartFile.fromPath("image", path);
    req.files.add(image);
    final res = await http.Response.fromStream(await req.send());
    final resData = jsonDecode(res.body) as Map<String, dynamic>;

    if (resData["cc"] == null) {
      debugPrint("null");
    } else {
      _currentCC = resData["cc"];
      debugPrint("recognized");
    }

    double newRate = calculatePlaybackRate(
        _currentCC.toDouble(), PKBAppState().pourAmount.toDouble());
    GlobalAudioPlayer().changeRateForRepeat(newRate);
    debugPrint("ESTIMATED CC: $_currentCC");
  }

  List<List<int>> reshape(List<int> flatList, int height, int width) {
    List<List<int>> reshaped =
        List.generate(height, (_) => List.filled(width, 0));
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        int index = i * width + j;
        if (index < flatList.length) {
          reshaped[i][j] = flatList[index];
        }
      }
    }
    return reshaped;
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // debugPrint(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // debugPrint('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // debugPrint('final rotation: $rotation');
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;
    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}