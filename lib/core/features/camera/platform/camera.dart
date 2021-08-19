import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformCameraView extends StatelessWidget {
  static const String _viewType = "flutter_platform_camera.cameraView";

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }
}
