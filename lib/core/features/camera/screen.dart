import 'package:flutter/material.dart';
import 'package:flutter_platform_camera/core/features/camera/platform/camera.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PlatformCameraView(),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
