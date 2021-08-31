import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_platform_camera/core/entities/photo.dart';

import 'repository.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository _repository;

  GalleryBloc(this._repository) : super(GalleryState.loading()) {
    _repository.allPhotos
        .then((value) => add(_GalleryEventExternal.dataReceived(data: value)));
  }

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is _GalleryEventExternalDataRecevied) {
      if (event.data.isError) {
        yield GalleryState.failure();
      } else {
        yield GalleryState.success(photos: event.data.asValue!.value);
      }
      return;
    }
  }
}

// --- State

abstract class GalleryState {
  factory GalleryState.loading() = GalleryStateLoading;

  factory GalleryState.failure() = GalleryStateFailure;

  factory GalleryState.success({
    required List<PhotoEntity> photos,
  }) = GalleryStateSuccess;
}

class GalleryStateLoading implements GalleryState {}

class GalleryStateFailure implements GalleryState {}

class GalleryStateSuccess implements GalleryState {
  final List<PhotoEntity> photos;

  GalleryStateSuccess({
    required this.photos,
  });
}

// --- Event

abstract class GalleryEvent {}

abstract class _GalleryEventExternal extends GalleryEvent {
  factory _GalleryEventExternal.dataReceived({
    required AllPhotosResult data,
  }) = _GalleryEventExternalDataRecevied;
}

class _GalleryEventExternalDataRecevied implements _GalleryEventExternal {
  final AllPhotosResult data;

  _GalleryEventExternalDataRecevied({
    required this.data,
  });
}
