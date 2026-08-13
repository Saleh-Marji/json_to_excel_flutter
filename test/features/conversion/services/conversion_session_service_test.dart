import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/features/conversion/models/export_format.dart';
import 'package:json_to_excel/features/conversion/models/field_mapping.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';

void main() {
  late ConversionSessionService sut;

  PathSegment seg(String key, JsonValueType type) {
    return PathSegment(key: key, type: type);
  }

  setUp(() {
    Get.put(JsonSchemaService());
    sut = ConversionSessionService();
    Get.put(sut);
  });

  tearDown(Get.reset);

  test('loadFromFile stores json, builds schema, and clears mappings', () async {
    sut.mappings.add(
      FieldMapping(
        path: [seg('old', JsonValueType.string)],
        columnName: 'Old',
      ),
    );

    await sut.loadFromFile(
      path: r'C:\data\orders.json',
      json: [
        {'name': 'Alice'},
        {'age': 30},
      ],
    );

    expect(sut.sourcePath.value, r'C:\data\orders.json');
    expect(sut.schema.value, isNotNull);
    expect(sut.schema.value!.valueType, JsonValueType.array);
    expect(sut.schema.value!.childWhere('name'), isNotNull);
    expect(sut.schema.value!.childWhere('age'), isNotNull);
    expect(sut.mappings, isEmpty);
    expect(sut.format.value, ExportFormat.xlsx);
  });

  test('defaultColumnName appends type when the key is already used', () {
    sut.upsertMapping(
      FieldMapping(
        path: [seg('customer', JsonValueType.object), seg('name', JsonValueType.string)],
        columnName: 'name',
      ),
    );

    expect(
      sut.defaultColumnName([
        seg('items', JsonValueType.array),
        seg('name', JsonValueType.string),
      ]),
      'name_string',
    );
  });

  test('hasUniqueColumnNames is false when two mappings share a name', () {
    sut.upsertMapping(
      FieldMapping(path: [seg('a', JsonValueType.string)], columnName: 'Col'),
    );
    sut.upsertMapping(
      FieldMapping(path: [seg('b', JsonValueType.string)], columnName: 'Col'),
    );

    expect(sut.hasUniqueColumnNames, isFalse);
  });

  test('reorderMappings changes the selected column order', () {
    final first = FieldMapping(
      path: [seg('a', JsonValueType.string)],
      columnName: 'A',
    );
    final second = FieldMapping(
      path: [seg('b', JsonValueType.string)],
      columnName: 'B',
    );
    sut.upsertMapping(first);
    sut.upsertMapping(second);

    sut.reorderMappings(0, 2);

    expect(sut.mappings.map((m) => m.columnName), ['B', 'A']);
  });
}
