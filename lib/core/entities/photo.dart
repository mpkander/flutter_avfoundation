import 'dart:convert';

class PhotoEntity {
  final String id;
  final String path;
  final DateTime creationDate;
  
  PhotoEntity({
    required this.id,
    required this.path,
    required this.creationDate,
  });

  PhotoEntity copyWith({
    String? id,
    String? path,
    DateTime? creationDate,
  }) {
    return PhotoEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory PhotoEntity.fromMap(Map<String, dynamic> map) {
    return PhotoEntity(
      id: map['id'],
      path: map['path'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoEntity.fromJson(String source) => PhotoEntity.fromMap(json.decode(source));

  @override
  String toString() => 'PhotoEntity(id: $id, path: $path, creationDate: $creationDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PhotoEntity &&
      other.id == id &&
      other.path == path &&
      other.creationDate == creationDate;
  }

  @override
  int get hashCode => id.hashCode ^ path.hashCode ^ creationDate.hashCode;
}
