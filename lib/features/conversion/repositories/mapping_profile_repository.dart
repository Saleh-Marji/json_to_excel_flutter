import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../../../constants/storage_keys.dart';
import '../models/mapping_profile.dart';

MappingProfileRepository get mappingProfileRepository =>
    Get.find<MappingProfileRepository>();

class MappingProfileRepository extends AppRepository {
  Future<List<MappingProfile>> loadAll() {
    return execute(() async {
      final raw = storageService.read(kStorageMappingProfiles);
      if (raw is! List) {
        return const <MappingProfile>[];
      }
      return raw
          .map(
            (e) => MappingProfile.fromJson(Map<dynamic, dynamic>.from(e as Map)),
          )
          .toList();
    });
  }

  Future<void> saveAll(List<MappingProfile> profiles) {
    return execute(() async {
      await storageService.write(
        kStorageMappingProfiles,
        profiles.map((p) => p.toJson()).toList(),
      );
    });
  }
}
