import 'field_mapping.dart';

/// Named snapshot of column mappings saved in preferences.
class MappingProfile {
  const MappingProfile({
    required this.name,
    required this.mappings,
  });

  final String name;
  final List<FieldMapping> mappings;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mappings': mappings.map((m) => m.toIsolateMap()).toList(),
    };
  }

  factory MappingProfile.fromJson(Map<dynamic, dynamic> json) {
    final rawMappings = json['mappings'] as List<dynamic>? ?? const [];
    return MappingProfile(
      name: json['name'] as String? ?? '',
      mappings: rawMappings
          .map(
            (e) => FieldMapping.fromIsolateMap(Map<dynamic, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }
}
