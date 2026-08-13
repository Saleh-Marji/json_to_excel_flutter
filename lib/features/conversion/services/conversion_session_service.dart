import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/export_format.dart';
import '../models/field_mapping.dart';
import '../models/path_segment.dart';
import '../models/schema_node.dart';
import 'json_schema_service.dart';

ConversionSessionService get conversionSessionService =>
    Get.find<ConversionSessionService>();

class ConversionSessionService extends AppService {
  final sourcePath = Rxn<String>();
  final parsedJson = Rxn<dynamic>();
  final schema = Rxn<SchemaNode>();
  final mappings = <FieldMapping>[].obs;
  final format = ExportFormat.xlsx.obs;
  final destinationPath = Rxn<String>();

  Future<void> loadFromFile({
    required String path,
    required dynamic json,
  }) {
    return runVoid(() async {
      sourcePath.value = path;
      parsedJson.value = json;
      schema.value = jsonSchemaService.build(json);
      mappings.clear();
      destinationPath.value = null;
      format.value = ExportFormat.xlsx;
    });
  }

  void reset() {
    sourcePath.value = null;
    parsedJson.value = null;
    schema.value = null;
    mappings.clear();
    destinationPath.value = null;
    format.value = ExportFormat.xlsx;
  }

  bool isPathMapped(List<PathSegment> path) {
    return mappings.any((m) => pathsEqual(m.path, path));
  }

  FieldMapping? mappingFor(List<PathSegment> path) {
    for (final mapping in mappings) {
      if (pathsEqual(mapping.path, path)) {
        return mapping;
      }
    }
    return null;
  }

  String defaultColumnName(List<PathSegment> path) {
    final used = mappings
        .where((m) => !pathsEqual(m.path, path))
        .map((m) => m.columnName)
        .toSet();
    final candidates = <String>[];
    if (path.isEmpty) {
      candidates.add('value');
    } else {
      final last = path.last;
      candidates.add(last.key.isEmpty ? last.type.name : last.key);
      if (last.key.isNotEmpty) {
        candidates.add('${last.key}_${last.type.name}');
      }
      final joined = path.map((s) => s.key).where((k) => k.isNotEmpty).join('_');
      if (joined.isNotEmpty) {
        candidates.add(joined);
      }
    }
    for (final name in candidates) {
      if (name.isNotEmpty && !used.contains(name)) {
        return name;
      }
    }
    final base = candidates.isEmpty ? 'column' : candidates.last;
    var i = 2;
    while (used.contains('$base$i')) {
      i++;
    }
    return '$base$i';
  }

  void upsertMapping(FieldMapping mapping) {
    final index = mappings.indexWhere((m) => pathsEqual(m.path, mapping.path));
    if (index >= 0) {
      mappings[index] = mapping;
    } else {
      mappings.add(mapping);
    }
  }

  void removeMapping(List<PathSegment> path) {
    mappings.removeWhere((m) => pathsEqual(m.path, path));
  }

  void reorderMappings(int oldIndex, int newIndex) {
    var target = newIndex;
    if (target > oldIndex) {
      target -= 1;
    }
    final item = mappings.removeAt(oldIndex);
    mappings.insert(target, item);
  }

  bool get hasUniqueColumnNames {
    final names = mappings.map((m) => m.columnName.trim()).toList();
    return names.length == names.toSet().length;
  }

  String suggestedFileName() {
    final source = sourcePath.value;
    final extension = format.value.fileExtension;
    if (source == null || source.isEmpty) {
      return 'export.$extension';
    }
    return '${p.basenameWithoutExtension(source)}.$extension';
  }

  void selectFormat(ExportFormat value) {
    format.value = value;
    final dest = destinationPath.value;
    if (dest != null && dest.isNotEmpty) {
      destinationPath.value = p.setExtension(dest, '.${value.fileExtension}');
    }
  }
}
