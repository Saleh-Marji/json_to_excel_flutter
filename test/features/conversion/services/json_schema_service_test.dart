import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';

void main() {
  late JsonSchemaService sut;

  setUp(() {
    sut = JsonSchemaService();
  });

  test('unions keys from every object in a list', () {
    final schema = sut.build([
      {'name': 'Alice', 'age': 30},
      {'name': 'Bob', 'email': 'bob@example.com'},
    ]);

    expect(schema.isLeaf, isFalse);
    expect(schema.valueType, JsonValueType.array);
    expect(schema.childWhere('name')!.isLeaf, isTrue);
    expect(schema.childWhere('name')!.example, 'Alice');
    expect(schema.childWhere('age')!.example, '30');
    expect(schema.childWhere('email')!.example, 'bob@example.com');
  });

  test('keeps nested objects and unions nested maps', () {
    final schema = sut.build([
      {
        'address': {'city': 'NYC', 'zip': '10001'},
      },
      {
        'address': {'city': 'LA'},
      },
    ]);

    final address = schema.childWhere('address', JsonValueType.object)!;
    expect(address.isLeaf, isFalse);
    expect(address.childWhere('city')!.example, 'NYC');
    expect(address.childWhere('zip')!.example, '10001');
  });

  test('treats primitive lists as a leaf array', () {
    final schema = sut.build({
      'tags': ['a', 'b'],
    });

    final tags = schema.childWhere('tags', JsonValueType.array)!;
    expect(tags.isLeaf, isTrue);
    expect(tags.children, isEmpty);
    expect(tags.example, 'a');
  });

  test('skips empty and null values when picking an example', () {
    final schema = sut.build([
      {'name': ''},
      {'name': null},
      {'name': '  '},
      {'name': 'Carol'},
    ]);

    expect(schema.childWhere('name')!.example, 'Carol');
  });

  test('keeps string and object variants of the same key', () {
    final schema = sut.build([
      {'address': 'plain'},
      {
        'address': {'city': 'NYC'},
      },
    ]);

    final variants = schema.childrenNamed('address');
    expect(variants, hasLength(2));
    expect(
      variants.map((n) => n.valueType),
      containsAll([JsonValueType.string, JsonValueType.object]),
    );
    expect(schema.childWhere('address', JsonValueType.string)!.example, 'plain');
    expect(
      schema.childWhere('address', JsonValueType.object)!.childWhere('city')!.example,
      'NYC',
    );
  });

  test('keeps number and string variants of the same key', () {
    final schema = sut.build([
      {'id': 1},
      {'id': 'abc'},
    ]);

    expect(schema.childWhere('id', JsonValueType.number)!.example, '1');
    expect(schema.childWhere('id', JsonValueType.string)!.example, 'abc');
  });

  test('builds a leaf schema for a primitive root', () {
    final schema = sut.build('hello');
    expect(schema.isLeaf, isTrue);
    expect(schema.valueType, JsonValueType.string);
    expect(schema.example, 'hello');
  });

  test('empty list is a leaf array', () {
    final schema = sut.build(<dynamic>[]);
    expect(schema.isLeaf, isTrue);
    expect(schema.valueType, JsonValueType.array);
  });

  test('hasLeafPath matches key and type on the current schema', () {
    final schema = sut.build({'name': 'Alice', 'age': 30});
    expect(
      schema.hasLeafPath(const [
        PathSegment(key: 'name', type: JsonValueType.string),
      ]),
      isTrue,
    );
    expect(
      schema.hasLeafPath(const [
        PathSegment(key: 'name', type: JsonValueType.number),
      ]),
      isFalse,
    );
    expect(
      schema.hasLeafPath(const [
        PathSegment(key: 'missing', type: JsonValueType.string),
      ]),
      isFalse,
    );
  });
}
