import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/features/conversion/models/field_mapping.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/mapping_profile.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/repositories/mapping_profile_repository.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';
import 'package:json_to_excel/features/conversion/services/mapping_profile_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

class MockMappingProfileRepository extends Mock
    implements MappingProfileRepository {}

void main() {
  late MockMappingProfileRepository repo;
  late MappingProfileService sut;

  PathSegment seg(String key, JsonValueType type) {
    return PathSegment(key: key, type: type);
  }

  setUpAll(() {
    registerFallbackValue(<MappingProfile>[]);
  });

  setUp(() {
    repo = MockMappingProfileRepository();
    Get.put<MappingProfileRepository>(repo);
    Get.put(JsonSchemaService());
    Get.put(ConversionSessionService());
    when(() => repo.loadAll()).thenAnswer((_) async => []);
    when(() => repo.saveAll(any())).thenAnswer((_) async {});
    sut = MappingProfileService();
    Get.put(sut);
  });

  tearDown(Get.reset);

  test('saveProfile rejects a duplicate name', () async {
    await sut.saveProfile(
      name: 'Orders',
      mappings: [
        FieldMapping(
          path: [seg('name', JsonValueType.string)],
          columnName: 'Name',
        ),
      ],
    );

    expect(
      () => sut.saveProfile(name: 'Orders', mappings: const []),
      throwsA(isA<ValidationException>()),
    );
    verify(() => repo.saveAll(any())).called(1);
  });

  test('apply keeps matching key+type paths in saved order', () async {
    await conversionSessionService.loadFromFile(
      path: 't.json',
      json: {
        'name': 'Alice',
        'age': 30,
      },
    );

    sut.apply(
      MappingProfile(
        name: 'P',
        mappings: [
          FieldMapping(
            path: [seg('name', JsonValueType.string)],
            columnName: 'Name',
          ),
          FieldMapping(
            path: [seg('missing', JsonValueType.string)],
            columnName: 'Missing',
          ),
          FieldMapping(
            path: [seg('age', JsonValueType.number)],
            columnName: 'Age',
          ),
          FieldMapping(
            path: [seg('age', JsonValueType.string)],
            columnName: 'AgeText',
          ),
        ],
      ),
    );

    expect(
      conversionSessionService.mappings.map((m) => m.columnName).toList(),
      ['Name', 'Age'],
    );
  });
}
