import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../platform/camera.dart';
import '../../navigation/routes.dart';
import 'bloc.dart';

class CameraScreen extends StatelessWidget {
  final _controller = PlaformCameraController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraBloc, CameraState>(
      listenWhen: (_, current) => current is CameraStateListenable,
      listener: (_, state) {
        if (state is CameraStateCapturePressed) {
          _controller.capturePhoto();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                        onPressed: () => context
                            .read<CameraBloc>()
                            .add(CameraEvent.capturePressed()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder<CameraBloc, CameraState>(
                            buildWhen: (_, current) =>
                                current is! CameraStateListenable,
                            builder: (_, state) => _GalleryButton(
                              imageProvider: state.photoEntity != null
                                  ? FileImage(
                                      state.photoEntity!.file,
                                      scale: 0.1,
                                    )
                                  : null,
                            ),
                          ),
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
  static const double _innerSpacing = 1.5;
  static const double _radius = 8;

  final ImageProvider? imageProvider;

  const _GalleryButton({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, PageRoutes.gallery()),
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(_innerSpacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius - _innerSpacing),
          child: imageProvider != null
              ? Image(
                  image: imageProvider!,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
        ),
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
