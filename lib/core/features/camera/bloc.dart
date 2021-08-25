import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/photo.dart';
import 'repository.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository _cameraRepository;

  CameraBloc(this._cameraRepository) : super(CameraState.normal()) {
    _cameraRepository.newestPhoto.listen((photo) {
      add(_CameraExternalEvent.photoReceived(photoEntity: photo));
    }).onError((e) {
      log("Error occured: \(e)");
    });
  }

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is _CameraEventPhotoReceived) {
      yield CameraState.galleryPhoto(photoEntity: event.photoEntity);
      return;
    }

    if (event is CameraEventCapturePressed) {
      yield CameraState.capturePressed(photoEntity: state.photoEntity);
    }
  }
}

// --- State ---

abstract class CameraState {
  PhotoEntity? get photoEntity;

  factory CameraState.normal({PhotoEntity? photoEntity}) = CameraStateNormal;
  factory CameraState.capturePressed({required PhotoEntity? photoEntity}) =
      CameraStateCapturePressed;
  factory CameraState.galleryPhoto({required PhotoEntity? photoEntity}) =
      CameraStateGalleryPhoto;
}

class CameraStateNormal implements CameraState {
  @override
  final PhotoEntity? photoEntity;

  CameraStateNormal({
    this.photoEntity,
  });
}

class CameraStateListenable {}

class CameraStateCapturePressed extends CameraStateNormal
    implements CameraStateListenable {
  CameraStateCapturePressed({
    required PhotoEntity? photoEntity,
  }) : super(photoEntity: photoEntity);
}

class CameraStateGalleryPhoto extends CameraStateNormal {
  CameraStateGalleryPhoto({
    required PhotoEntity? photoEntity,
  }) : super(photoEntity: photoEntity);
}

// --- Event ---

abstract class CameraEvent {
  factory CameraEvent.capturePressed() = CameraEventCapturePressed;
}

abstract class _CameraExternalEvent extends CameraEvent {
  factory _CameraExternalEvent.photoReceived(
      {required PhotoEntity photoEntity}) = _CameraEventPhotoReceived;
}

class CameraEventCapturePressed implements CameraEvent {}

class _CameraEventPhotoReceived implements _CameraExternalEvent {
  final PhotoEntity photoEntity;

  _CameraEventPhotoReceived({
    required this.photoEntity,
  });
}
