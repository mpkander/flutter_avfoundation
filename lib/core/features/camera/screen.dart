
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../platform/camera.dart';

class CameraScreen extends StatelessWidget {
  final _controller = PlaformCameraController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              _buildCamera(context),
              Positioned(
                left: 30,
                right: 30,
                bottom: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _CaptureButton(
                      onPressed: () async {
                        await _controller.capturePhoto();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _GalleryButton(),
                        _FlipButton(
                          onPressed: () => _controller.flipCamera(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCamera(BuildContext context) {
    const Radius _borderRadius = Radius.circular(8);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: _borderRadius,
        topRight: _borderRadius,
      ),
      child: PlatformCameraView(
        controller: _controller,
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  static const double _size = 72;

  final VoidCallback onPressed;

  const _CaptureButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  static const double _size = 38;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _FlipButton extends StatelessWidget {
  static const double _size = 38;

  final VoidCallback onPressed;

  const _FlipButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: _size,
      onPressed: onPressed,
      color: Colors.white,
      icon: Icon(CupertinoIcons.arrow_2_circlepath),
    );
  }
}
