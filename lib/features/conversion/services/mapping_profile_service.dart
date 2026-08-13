import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/field_mapping.dart';
import '../models/mapping_profile.dart';
import '../repositories/mapping_profile_repository.dart';
import 'conversion_session_service.dart';

MappingProfileService get mappingProfileService =>
    Get.find<MappingProfileService>();

class MappingProfileService extends AppService {
  final profiles = <MappingProfile>[].obs;

  Future<void> load() {
    return runVoid(() async {
      profiles.assignAll(await mappingProfileRepository.loadAll());
    });
  }

  Future<void> saveProfile({
    required String name,
    required List<FieldMapping> mappings,
  }) {
    return runVoid(() async {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const ValidationException(
          message: 'Enter a profile name.',
        );
      }
      if (profiles.any((p) => p.name == trimmed)) {
        throw const ValidationException(
          message: 'A profile with this name already exists.',
        );
      }
      final next = [
        ...profiles,
        MappingProfile(name: trimmed, mappings: List.of(mappings)),
      ];
      await mappingProfileRepository.saveAll(next);
      profiles.assignAll(next);
    });
  }

  void apply(MappingProfile profile) {
    final schema = conversionSessionService.schema.value;
    if (schema == null) {
      conversionSessionService.mappings.clear();
      return;
    }
    final kept = profile.mappings
        .where((m) => schema.hasLeafPath(m.path))
        .toList();
    conversionSessionService.mappings.assignAll(kept);
  }
}
