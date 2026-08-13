import 'path_segment.dart';

/// Maps a JSON leaf path to an Excel/CSV column name.
class FieldMapping {
  const FieldMapping({
    required this.path,
    required this.columnName,
  });

  /// Path from the schema root to the leaf. Empty means the root value.
  final List<PathSegment> path;

  final String columnName;

  String get pathLabel => pathLabelOf(path);

  /// Stable key used while exploding rows.
  String get pathKey => pathKeyOf(path);

  FieldMapping copyWith({
    List<PathSegment>? path,
    String? columnName,
  }) {
    return FieldMapping(
      path: path ?? this.path,
      columnName: columnName ?? this.columnName,
    );
  }

  Map<String, dynamic> toIsolateMap() {
    return {
      'path': path.map((s) => s.toIsolateMap()).toList(),
      'columnName': columnName,
    };
  }

  factory FieldMapping.fromIsolateMap(Map<dynamic, dynamic> map) {
    final rawPath = map['path'] as List<dynamic>? ?? const [];
    return FieldMapping(
      path: rawPath
          .map((e) => PathSegment.fromIsolateMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList(),
      columnName: map['columnName'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FieldMapping &&
        other.columnName == columnName &&
        pathSegmentsEqual(other.path, path);
  }

  @override
  int get hashCode => Object.hash(columnName, Object.hashAll(path));
}

bool pathsEqual(List<PathSegment> a, List<PathSegment> b) =>
    pathSegmentsEqual(a, b);
