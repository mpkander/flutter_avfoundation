import 'dart:convert';

class ImageDto {
  final String uuid;
  final String inMemoryPath;
  final DateTime creationDate;
  
  ImageDto({
    required this.uuid,
    required this.inMemoryPath,
    required this.creationDate,
  });

  ImageDto copyWith({
    String? uuid,
    String? inMemoryPath,
    DateTime? creationDate,
  }) {
    return ImageDto(
      uuid: uuid ?? this.uuid,
      inMemoryPath: inMemoryPath ?? this.inMemoryPath,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'inMemoryPath': inMemoryPath,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ImageDto.fromMap(Map<String, dynamic> map) {
    return ImageDto(
      uuid: map['uuid'],
      inMemoryPath: map['inMemoryPath'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageDto.fromJson(String source) => ImageDto.fromMap(json.decode(source));

  @override
  String toString() => 'ImageDto(uuid: $uuid, inMemoryPath: $inMemoryPath, creationDate: $creationDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ImageDto &&
      other.uuid == uuid &&
      other.inMemoryPath == inMemoryPath &&
      other.creationDate == creationDate;
  }

  @override
  int get hashCode => uuid.hashCode ^ inMemoryPath.hashCode ^ creationDate.hashCode;
}
