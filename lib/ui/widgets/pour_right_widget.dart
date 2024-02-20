import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:core';
import 'package:matrix2d/matrix2d.dart';


class PourRightWidget extends StatefulWidget {
  
  const PourRightWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);
  final double? width;
  final double? height;
  @override
  State<PourRightWidget> createState() => _CameraViewState();
}
class _CameraViewState extends State<PourRightWidget> {
  static List<CameraDescription> _cameras = [];
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String? _recognizedText; // 인식된 텍스트
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  bool _changingCameraLens = false;
  Timer? _pictureTimer;
  bool _isBusy = false;
  bool _canProcess = true;
  int _currentCC = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
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
    _stopLiveFeed();
    _textRecognizer.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
            child: _changingCameraLens
                ? const Center(
                    child: Text('Changing camera lens'),
                  )
                : CameraPreview(
                    _controller!,
                    child: null,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _detectionViewModeToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            onPressed: () {},
            heroTag: Object(),
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.photo_library_outlined,
              size: 25,
            ),
          ),
        ),
      );
  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 8,
        right: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: _switchLiveCamera,
            backgroundColor: Colors.black54,
            child: Icon(
              Platform.isIOS
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_android_outlined,
              size: 25,
            ),
          ),
        ),
      );
  Widget _zoomControl() => Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Slider(
                    value: _currentZoomLevel,
                    min: _minAvailableZoom,
                    max: _maxAvailableZoom,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentZoomLevel = value;
                      });
                      await _controller?.setZoomLevel(value);
                    },
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${_currentZoomLevel.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget _exposureControl() => Positioned(
        top: 40,
        right: 8,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 250,
          ),
          child: Column(children: [
            Container(
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${_currentExposureOffset.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  height: 30,
                  child: Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentExposureOffset = value;
                      });
                      await _controller?.setExposureOffset(value);
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      );
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
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        //widget.onCameraFeedReady!();
        //widget.onCameraLensDirectionChanged!(camera.lensDirection);
      });
      _pictureTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _takePicture();
      });
      setState(() {});
    });
  }
  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      // Check if the controller is initialized
      print("Controller is not initialized");
      return;
    }
    if (_controller!.value.isTakingPicture) {
      // If a capture is already pending, do not take another
      return;
    }
    try {
      final picture = await _controller!.takePicture();
      await _detectObject(picture);
      await _analyzePicture(picture);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _detectObject(XFile picture) async {
    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      "${DateTime.now()}-detect.jpg",
    );
    await picture.saveTo(path);
    final File file = File(path);
    final inputImage = InputImage.fromFile(file);
    
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
  Future<void> _analyzePicture(XFile picture) async {
    const crop_w0 = 30;
    const crop_w1 = 50;
    const crop_h0 = 30;
    const crop_h1 = 50;
    if (!_canProcess) return;
    if (_isBusy) return;
    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      "${DateTime.now()}.jpg",
    );
    await picture.saveTo(path);
    final File file = File(path);
    final scales = await _get_scale_positions(file);
    final level = _get_liquid_level(file, crop_w0, crop_w1, crop_h0, crop_h1);
    final cc = _estimate_cc(scales, level);
    _currentCC = cc;
    print("ESTIMATED CC: ${cc}");
    _isBusy = false;
  }
  int _get_liquid_level(
      File file, int crop_w0, int crop_w1, int crop_h0, int crop_h1,
      [int threshold_binarize = 100, int threshold_level = 5]) {
    img.Image? image = img.decodeJpg(file.readAsBytesSync());
    Uint8List arr_image = image!.getBytes(order: img.ChannelOrder.rgb);
    final arr = arr_image
        .reshape(3, arr_image.length ~/ 3)
        .map((x) => (x[0] + x[1] + x[2]) / 3)
        .toList()
        .map((x) => x >= threshold_binarize ? 1 : 0)
        .toList()
        .reshape(image.height, image.width);
    final arr_sum = arr
        .sublist(crop_h0, crop_h1)
        .map((x) => x.sublist(crop_w0, crop_w1))
        .toList()
        .map((x) => x.reduce((a, b) => a + b))
        .toList();
    for (var entry in arr_sum.asMap().entries) {
      int i = entry.key;
      int v = entry.value;
      if (v < threshold_level) {
        return i + crop_h0;
      }
    }
    return crop_h1;
  }
  Future<List<int?>> _get_scale_positions(File file) async {
    final inputImage = InputImage.fromFile(file);
    List<int?> positions = List.filled(20, null);
    final text = await _textRecognizer.processImage(inputImage);
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print("ELEMENT: ${element.text} ${element.boundingBox.center}");
          final parsed = int.tryParse(element.text);
          if (parsed != null && parsed <= 20) {
            final y =
                (element.cornerPoints[0].y + element.boundingBox.center.dy)
                    .round();
            positions[parsed] = y;
          }
        }
      }
    }
    return positions;
  }
  int _estimate_cc(List<int?> scales, int level) {
    int cc = 0;
    int min = 1000;
    for (var entry in scales.asMap().entries) {
      int i = entry.key;
      int? s = entry.value;
      if (s != null) {
        final dd = (level - s) * (level - s);
        if (dd < min) {
          cc = i + 1;
          min = dd;
        }
      }
    }
    return cc;
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
  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }
  void _processCameraImage(CameraImage image) {
    // final grayScaleImage = img.grayscale(image);
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    //widget.onImage(inputImage);
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
    // print(
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
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');
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