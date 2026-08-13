import 'json_value_type.dart';
import 'path_segment.dart';

/// Merged JSON schema node. Same key + different type stay as siblings.
class SchemaNode {
  const SchemaNode({
    required this.name,
    required this.valueType,
    required this.isLeaf,
    this.children = const [],
    this.example,
  });

  /// JSON key. Empty at the document root.
  final String name;

  final JsonValueType valueType;

  /// True when this node is a primitive or a primitive-only array.
  final bool isLeaf;

  /// Nested keys. May contain multiple nodes with the same [name] and different [valueType].
  final List<SchemaNode> children;

  /// First non-empty sample value from the JSON, if any.
  final String? example;

  bool get isArray => valueType == JsonValueType.array;

  bool get isObjectLike => !isLeaf;

  PathSegment get segment => PathSegment(key: name, type: valueType);

  SchemaNode? childWhere(String key, [JsonValueType? type]) {
    for (final child in children) {
      if (child.name == key && (type == null || child.valueType == type)) {
        return child;
      }
    }
    return null;
  }

  List<SchemaNode> childrenNamed(String key) {
    return children.where((c) => c.name == key).toList();
  }

  /// True when [path] resolves to a leaf on this node (document root).
  bool hasLeafPath(List<PathSegment> path) {
    if (path.isEmpty) {
      return isLeaf;
    }
    SchemaNode current = this;
    for (final segment in path) {
      final next = current.childWhere(segment.key, segment.type);
      if (next == null) {
        return false;
      }
      current = next;
    }
    return current.isLeaf;
  }

  SchemaNode copyWith({
    String? name,
    JsonValueType? valueType,
    bool? isLeaf,
    List<SchemaNode>? children,
    String? example,
  }) {
    return SchemaNode(
      name: name ?? this.name,
      valueType: valueType ?? this.valueType,
      isLeaf: isLeaf ?? this.isLeaf,
      children: children ?? this.children,
      example: example ?? this.example,
    );
  }
}
