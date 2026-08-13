import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/features/conversion/models/field_mapping.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/screen_controllers/mapping_controller.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';

void main() {
  late MappingController sut;

  setUp(() {
    Get.testMode = true;
    Get.put(JsonSchemaService());
    Get.put(ConversionSessionService());
    sut = MappingController();
    Get.put(sut);
  });

  tearDown(Get.reset);

  test('removeMapping deletes the mapping from the session', () {
    final mapping = FieldMapping(
      path: const [PathSegment(key: 'name', type: JsonValueType.string)],
      columnName: 'Name',
    );
    conversionSessionService.upsertMapping(mapping);
    sut.removeMapping(mapping);
    expect(conversionSessionService.mappings, isEmpty);
  });

  test('reorderMappings delegates to the session', () {
    conversionSessionService.upsertMapping(
      const FieldMapping(
        path: [PathSegment(key: 'a', type: JsonValueType.string)],
        columnName: 'A',
      ),
    );
    conversionSessionService.upsertMapping(
      const FieldMapping(
        path: [PathSegment(key: 'b', type: JsonValueType.string)],
        columnName: 'B',
      ),
    );
    sut.reorderMappings(0, 2);
    expect(
      conversionSessionService.mappings.map((m) => m.columnName),
      ['B', 'A'],
    );
  });
}
