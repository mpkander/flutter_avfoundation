import 'dart:developer';

import 'package:flutter/services.dart';

import 'model.dart';

abstract class ImageStoragePlatform {
  Stream<List<ImageDto>> get onImageStorageDataChanged;
  Future<List<ImageDto>> get allImages;
  Future<void> deleteImages(List<String> uuids);
}

class ImageStoragePlatformImpl implements ImageStoragePlatform {
  final _methodChannel = MethodChannel("flutter_platform_camera.image_storage");

  final _eventChannel =
      EventChannel("flutter_platform_camera.image_storage_observer");

  Stream<List<ImageDto>>? _onImageStorageDataChanged;

  @override
  Stream<List<ImageDto>> get onImageStorageDataChanged =>
      _onImageStorageDataChanged ??=
          _eventChannel.receiveBroadcastStream().map(_parseImageStorageResult);

  @override
  Future<List<ImageDto>> get allImages => _methodChannel.invokeListMethod<>(method);
}

List<ImageDto> _parseImageStorageResult(dynamic result) {
  log("result: $result");

  final listMapResult = result as List;

  return listMapResult
      .map((e) => ImageDto(
            uuid: e["uuid"],
            inMemoryPath: e["path"],
            creationDate: DateTime.fromMillisecondsSinceEpoch(
                e["creationTimestamp"] * 1000),
          ))
      .toList();
}
