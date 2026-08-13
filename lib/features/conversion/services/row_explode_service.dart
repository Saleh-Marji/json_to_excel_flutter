import 'dart:convert';

import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/field_mapping.dart';
import '../models/json_value_type.dart';
import '../models/path_segment.dart';

RowExplodeService get rowExplodeService => Get.find<RowExplodeService>();

/// Turns JSON into table rows by exploding lists on selected mapping paths.
class RowExplodeService extends AppService {
  /// Returns rows aligned to [mappings] order. Empty rows are omitted.
  List<List<String>> explode({
    required dynamic json,
    required List<FieldMapping> mappings,
    void Function(int current, int total)? onRootProgress,
  }) {
    if (mappings.isEmpty) {
      return const [];
    }
    final selectedPaths = mappings.map((m) => m.path).toList();
    final rawRows = <Map<String, String>>[];

    if (json is List) {
      final total = json.length;
      if (total == 0) {
        onRootProgress?.call(0, 0);
        return const [];
      }
      for (var i = 0; i < json.length; i++) {
        rawRows.addAll(_explodeAt(json[i], const [], selectedPaths));
        onRootProgress?.call(i + 1, total);
      }
    } else {
      onRootProgress?.call(0, 1);
      rawRows.addAll(_explodeAt(json, const [], selectedPaths));
      onRootProgress?.call(1, 1);
    }

    final table = <List<String>>[];
    for (final raw in rawRows) {
      final cells = <String>[];
      var hasValue = false;
      for (final mapping in mappings) {
        final value = raw[mapping.pathKey] ?? '';
        cells.add(value);
        if (value.trim().isNotEmpty) {
          hasValue = true;
        }
      }
      if (hasValue) {
        table.add(cells);
      }
    }
    return table;
  }

  List<Map<String, String>> _explodeAt(
    dynamic value,
    List<PathSegment> currentPath,
    List<List<PathSegment>> selectedPaths,
  ) {
    final relevant = selectedPaths
        .where((path) => pathStartsWith(path, currentPath))
        .toList();
    if (relevant.isEmpty) {
      return [{}];
    }

    if (value is List) {
      if (value.isEmpty) {
        return const [];
      }
      final rows = <Map<String, String>>[];
      for (final item in value) {
        rows.addAll(_explodeAt(item, currentPath, selectedPaths));
      }
      return rows;
    }

    if (value is Map) {
      final nextSegments = <PathSegment>[];
      for (final path in relevant) {
        if (path.length > currentPath.length) {
          final next = path[currentPath.length];
          if (!nextSegments.contains(next)) {
            nextSegments.add(next);
          }
        }
      }
      if (nextSegments.isEmpty) {
        return [{}];
      }

      final dimensions = <List<Map<String, String>>>[];
      for (final segment in nextSegments) {
        final childPath = [...currentPath, segment];
        if (!value.containsKey(segment.key)) {
          dimensions.add([_emptyFor(childPath, relevant)]);
          continue;
        }
        final child = value[segment.key];
        if (!segment.type.matches(child)) {
          dimensions.add([_emptyFor(childPath, relevant)]);
          continue;
        }
        dimensions.add(_explodeAt(child, childPath, selectedPaths));
      }
      return _cartesian(dimensions);
    }

    final result = <String, String>{};
    for (final path in relevant) {
      if (path.length == currentPath.length) {
        result[pathKeyOf(path)] = _stringify(value);
      } else {
        result[pathKeyOf(path)] = '';
      }
    }
    return [result];
  }

  Map<String, String> _emptyFor(
    List<PathSegment> childPath,
    List<List<PathSegment>> relevant,
  ) {
    final empty = <String, String>{};
    for (final path in relevant) {
      if (pathStartsWith(path, childPath)) {
        empty[pathKeyOf(path)] = '';
      }
    }
    return empty;
  }

  List<Map<String, String>> _cartesian(List<List<Map<String, String>>> dims) {
    var acc = <Map<String, String>>[{}];
    for (final dim in dims) {
      if (dim.isEmpty) {
        return const [];
      }
      final next = <Map<String, String>>[];
      for (final left in acc) {
        for (final right in dim) {
          next.add({...left, ...right});
        }
      }
      acc = next;
    }
    return acc;
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
