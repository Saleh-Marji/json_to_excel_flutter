import 'dart:convert';

import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/json_value_type.dart';
import '../models/schema_node.dart';

JsonSchemaService get jsonSchemaService => Get.find<JsonSchemaService>();

/// Builds a nested schema where JSON arrays become a union of their elements.
/// Same key with different types is kept as sibling nodes.
class JsonSchemaService extends AppService {
  SchemaNode build(dynamic json) => _fromValue(json);

  SchemaNode _fromValue(dynamic value, {String name = ''}) {
    if (value is List) {
      return _fromList(value, name: name);
    }
    if (value is Map) {
      final children = <SchemaNode>[];
      for (final entry in value.entries) {
        if (entry.value == null) {
          continue;
        }
        children.add(_fromValue(entry.value, name: entry.key.toString()));
      }
      return SchemaNode(
        name: name,
        valueType: JsonValueType.object,
        isLeaf: false,
        children: children,
      );
    }
    return SchemaNode(
      name: name,
      valueType: JsonValueTypeX.of(value) ?? JsonValueType.string,
      isLeaf: true,
      example: _nonEmptyExample(value),
    );
  }

  SchemaNode _fromList(List<dynamic> value, {required String name}) {
    if (value.isEmpty) {
      return SchemaNode(
        name: name,
        valueType: JsonValueType.array,
        isLeaf: true,
      );
    }
    var children = <SchemaNode>[];
    String? example;
    var sawObject = false;
    for (final item in value) {
      if (item == null) {
        continue;
      }
      final node = _fromValue(item);
      if (node.isLeaf && node.valueType != JsonValueType.array) {
        example = _firstExample(example, node.example);
        continue;
      }
      if (node.valueType == JsonValueType.array && node.isLeaf) {
        example = _firstExample(example, node.example);
        continue;
      }
      sawObject = true;
      children = _mergeChildLists(children, node.children);
    }
    if (!sawObject) {
      return SchemaNode(
        name: name,
        valueType: JsonValueType.array,
        isLeaf: true,
        example: example,
      );
    }
    return SchemaNode(
      name: name,
      valueType: JsonValueType.array,
      isLeaf: false,
      children: children,
      example: example,
    );
  }

  List<SchemaNode> _mergeChildLists(List<SchemaNode> a, List<SchemaNode> b) {
    var result = [...a];
    for (final child in b) {
      result = _addOrMerge(result, child);
    }
    return result;
  }

  List<SchemaNode> _addOrMerge(List<SchemaNode> children, SchemaNode incoming) {
    final index = children.indexWhere(
      (c) => c.name == incoming.name && c.valueType == incoming.valueType,
    );
    if (index < 0) {
      return [...children, incoming];
    }
    final merged = [...children];
    merged[index] = _unionSameType(children[index], incoming);
    return merged;
  }

  SchemaNode _unionSameType(SchemaNode a, SchemaNode b) {
    if (a.isLeaf && b.isLeaf) {
      return SchemaNode(
        name: a.name,
        valueType: a.valueType,
        isLeaf: true,
        example: _firstExample(a.example, b.example),
      );
    }
    return SchemaNode(
      name: a.name,
      valueType: a.valueType,
      isLeaf: false,
      children: _mergeChildLists(a.children, b.children),
      example: _firstExample(a.example, b.example),
    );
  }

  String? _firstExample(String? a, String? b) {
    if (a != null && a.trim().isNotEmpty) {
      return a;
    }
    if (b != null && b.trim().isNotEmpty) {
      return b;
    }
    return null;
  }

  String? _nonEmptyExample(dynamic value) {
    final text = _stringify(value).trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }

  String _stringify(dynamic value) {
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    return jsonEncode(value);
  }
}
