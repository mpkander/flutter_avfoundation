import 'dart:io';

import '../../platform/image_storage/model.dart';

class PhotoEntity {
  final String id;
  final File file;
  final DateTime creationDate;

  PhotoEntity({
    required this.id,
    required this.file,
    required this.creationDate,
  });

  PhotoEntity copyWith({
    String? id,
    File? file,
    DateTime? creationDate,
  }) {
    return PhotoEntity(
      id: id ?? this.id,
      file: file ?? this.file,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() =>
      'PhotoEntity(id: $id, file: $file, creationDate: $creationDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoEntity &&
        other.id == id &&
        other.file == file &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode => id.hashCode ^ file.hashCode ^ creationDate.hashCode;
}

extension PhotoEntityAdapter on ImageDto {
  PhotoEntity toDomain() => PhotoEntity(
        id: uuid,
        file: File(inMemoryPath),
        creationDate: creationDate,
      );
}
