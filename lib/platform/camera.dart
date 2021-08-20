import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _viewType = "flutter_platform_camera.cameraView";

class PlatformCameraView extends StatelessWidget {
  final PlaformCameraController? controller;

  PlatformCameraView({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }

  void _onPlatformViewCreated(int id) {
    controller?.channelId = id;
  }
}

class PlaformCameraController {
  late final CameraPlatformApi? _cameraPlatformApi;

  set channelId(int id) {
    _cameraPlatformApi = CameraPlatformApi.fromViewId(id);
    _platformApiInitCompleter.complete();
  }

  final _platformApiInitCompleter = Completer<void>();

  Future<Uint8List?> capturePhoto() async {
    await _platformApiInitCompleter.future;

    Uint8List? result;

    try {
      result = await _cameraPlatformApi?.capturePhoto();
    } catch (e) {
      log(e.toString());
    }

    return result;
  }

  Future<void> flipCamera() async {
    await _platformApiInitCompleter.future;

    try {
      await _cameraPlatformApi?.flipCamera();
    } catch (e) {
      log(e.toString());
    }
  }
}

class CameraPlatformApi {
  final MethodChannel _channel;

  CameraPlatformApi.fromViewId(int id)
      : _channel = MethodChannel("${_viewType}_$id");

  Future<Uint8List> capturePhoto() async {
    final Uint8List result;

    try {
      result = await _channel.invokeMethod("capturePhoto");
    } catch (e) {
      throw CameraError("capturePhoto failed: $e");
    }

    return result;
  }

  Future<void> flipCamera() async {
    try {
      await _channel.invokeMethod("flipCamera");
    } catch (e) {
      throw CameraError("flipCamera failed: $e");
    }
  }
}

class CameraError {
  final String message;

  CameraError(this.message);

  @override
  String toString() => 'CameraError(message: $message)';
}
