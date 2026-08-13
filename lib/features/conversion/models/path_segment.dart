import 'json_value_type.dart';

/// One step in a mapped JSON path, including the value type at that key.
class PathSegment {
  const PathSegment({
    required this.key,
    required this.type,
  });

  final String key;
  final JsonValueType type;

  String get pathKeyPart => '$key\u001f${type.name}';

  Map<String, dynamic> toIsolateMap() {
    return {
      'key': key,
      'type': type.name,
    };
  }

  factory PathSegment.fromIsolateMap(Map<dynamic, dynamic> map) {
    return PathSegment(
      key: map['key'] as String? ?? '',
      type: JsonValueType.values.byName(map['type'] as String? ?? 'string'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PathSegment && other.key == key && other.type == type;
  }

  @override
  int get hashCode => Object.hash(key, type);
}

bool pathSegmentsEqual(List<PathSegment> a, List<PathSegment> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

bool pathStartsWith(List<PathSegment> path, List<PathSegment> prefix) {
  if (prefix.length > path.length) {
    return false;
  }
  for (var i = 0; i < prefix.length; i++) {
    if (path[i] != prefix[i]) {
      return false;
    }
  }
  return true;
}

String pathKeyOf(List<PathSegment> path) {
  return path.map((s) => s.pathKeyPart).join('\u001e');
}

String pathLabelOf(List<PathSegment> path) {
  if (path.isEmpty) {
    return '';
  }
  final keys = path.map((s) => s.key).where((k) => k.isNotEmpty).join('.');
  final type = path.last.type.name;
  if (keys.isEmpty) {
    return type;
  }
  return '$keys ($type)';
}
