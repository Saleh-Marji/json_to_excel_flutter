/// JSON runtime type used to keep same-named keys distinct in the schema.
enum JsonValueType {
  string,
  number,
  boolean,
  object,
  array,
}

extension JsonValueTypeX on JsonValueType {
  bool matches(dynamic value) {
    switch (this) {
      case JsonValueType.string:
        return value is String;
      case JsonValueType.number:
        return value is num;
      case JsonValueType.boolean:
        return value is bool;
      case JsonValueType.object:
        return value is Map;
      case JsonValueType.array:
        return value is List;
    }
  }

  static JsonValueType? of(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return JsonValueType.string;
    }
    if (value is num) {
      return JsonValueType.number;
    }
    if (value is bool) {
      return JsonValueType.boolean;
    }
    if (value is List) {
      return JsonValueType.array;
    }
    if (value is Map) {
      return JsonValueType.object;
    }
    return null;
  }
}
