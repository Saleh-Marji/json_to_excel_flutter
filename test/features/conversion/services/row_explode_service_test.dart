import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_excel/features/conversion/models/field_mapping.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/services/row_explode_service.dart';

void main() {
  late RowExplodeService sut;

  setUp(() {
    sut = RowExplodeService();
  });

  PathSegment seg(String key, JsonValueType type) {
    return PathSegment(key: key, type: type);
  }

  FieldMapping map(List<PathSegment> path, [String? name]) {
    return FieldMapping(
      path: path,
      columnName: name ?? path.last.key,
    );
  }

  test('explodes a nested list and repeats parent fields', () {
    final json = [
      {
        'orderId': '1',
        'items': [
          {'sku': 'A', 'qty': 1},
          {'sku': 'B', 'qty': 2},
        ],
      },
      {
        'orderId': '2',
        'items': [
          {'sku': 'C', 'qty': 3},
        ],
      },
    ];

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('orderId', JsonValueType.string)]),
        map([
          seg('items', JsonValueType.array),
          seg('sku', JsonValueType.string),
        ]),
        map([
          seg('items', JsonValueType.array),
          seg('qty', JsonValueType.number),
        ]),
      ],
    );

    expect(rows, [
      ['1', 'A', '1'],
      ['1', 'B', '2'],
      ['2', 'C', '3'],
    ]);
  });

  test('does not explode a nested list that is not on a selected path', () {
    final json = [
      {
        'orderId': '1',
        'items': [
          {'sku': 'A'},
          {'sku': 'B'},
        ],
      },
    ];

    final rows = sut.explode(
      json: json,
      mappings: [map([seg('orderId', JsonValueType.string)])],
    );

    expect(rows, [
      ['1'],
    ]);
  });

  test('cartesian-explodes sibling lists on selected paths', () {
    final json = {
      'id': 1,
      'items': [
        {'sku': 'A'},
        {'sku': 'B'},
      ],
      'tags': [
        {'label': 'x'},
        {'label': 'y'},
      ],
    };

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('id', JsonValueType.number)]),
        map([
          seg('items', JsonValueType.array),
          seg('sku', JsonValueType.string),
        ]),
        map([
          seg('tags', JsonValueType.array),
          seg('label', JsonValueType.string),
        ]),
      ],
    );

    expect(rows, [
      ['1', 'A', 'x'],
      ['1', 'A', 'y'],
      ['1', 'B', 'x'],
      ['1', 'B', 'y'],
    ]);
  });

  test('skips rows where every mapped cell is empty', () {
    final json = [
      {'name': 'Alice'},
      {'other': 'ignored'},
      {'name': ''},
    ];

    final rows = sut.explode(
      json: json,
      mappings: [map([seg('name', JsonValueType.string)])],
    );

    expect(rows, [
      ['Alice'],
    ]);
  });

  test('puts empty when a mapped key is missing on an object', () {
    final json = [
      {'name': 'Alice', 'age': 30},
      {'name': 'Bob'},
    ];

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('name', JsonValueType.string)]),
        map([seg('age', JsonValueType.number)]),
      ],
    );

    expect(rows, [
      ['Alice', '30'],
      ['Bob', ''],
    ]);
  });

  test('explodes a primitive list into one row per value', () {
    final json = {
      'id': 1,
      'tags': ['a', 'b'],
    };

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('id', JsonValueType.number)]),
        map([seg('tags', JsonValueType.array)]),
      ],
    );

    expect(rows, [
      ['1', 'a'],
      ['1', 'b'],
    ]);
  });

  test('empty nested list on a selected path yields no rows for that parent', () {
    final json = [
      {
        'orderId': '1',
        'items': <dynamic>[],
      },
    ];

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('orderId', JsonValueType.string)]),
        map([
          seg('items', JsonValueType.array),
          seg('sku', JsonValueType.string),
        ]),
      ],
    );

    expect(rows, isEmpty);
  });

  test('fills only the mapping whose type matches the value', () {
    final json = [
      {'id': 1},
      {'id': 'abc'},
    ];

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('id', JsonValueType.number)], 'id_number'),
        map([seg('id', JsonValueType.string)], 'id_string'),
      ],
    );

    expect(rows, [
      ['1', ''],
      ['', 'abc'],
    ]);
  });

  test('column order follows the mappings list order', () {
    final json = [
      {'name': 'Alice', 'age': 30},
    ];

    final rows = sut.explode(
      json: json,
      mappings: [
        map([seg('age', JsonValueType.number)]),
        map([seg('name', JsonValueType.string)]),
      ],
    );

    expect(rows, [
      ['30', 'Alice'],
    ]);
  });
}
