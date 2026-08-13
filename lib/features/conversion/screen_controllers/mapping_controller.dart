import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../../../constants/localizations.dart';
import '../../../constants/routes.dart';
import '../models/field_mapping.dart';
import '../models/mapping_profile.dart';
import '../models/path_segment.dart';
import '../services/conversion_session_service.dart';
import '../services/mapping_profile_service.dart';
import '../widgets/column_name_dialog.dart';

MappingController get mappingController => Get.find<MappingController>();

class MappingController extends AppScreenController {
  final saveProfileEnabled = false.obs;
  final profileNameController = TextEditingController();

  @override
  void onClose() {
    profileNameController.dispose();
    super.onClose();
  }

  void setSaveProfileEnabled(bool value) {
    saveProfileEnabled.value = value;
  }

  Future<void> selectLeaf(List<PathSegment> path) {
    return performSilent(() async {
      final existing = conversionSessionService.mappingFor(path);
      final initial = existing?.columnName ??
          conversionSessionService.defaultColumnName(path);
      final name = await ColumnNameDialog.show(initialName: initial);
      if (name == null) {
        return;
      }
      conversionSessionService.upsertMapping(
        FieldMapping(path: path, columnName: name),
      );
    });
  }

  Future<void> editMapping(FieldMapping mapping) {
    return selectLeaf(mapping.path);
  }

  void removeMapping(FieldMapping mapping) {
    conversionSessionService.removeMapping(mapping.path);
  }

  void reorderMappings(int oldIndex, int newIndex) {
    conversionSessionService.reorderMappings(oldIndex, newIndex);
  }

  Future<void> applyProfile(MappingProfile profile) {
    return performSilent(() async {
      mappingProfileService.apply(profile);
    });
  }

  Future<void> continueToExport() {
    return performSilent(() async {
      if (conversionSessionService.mappings.isEmpty) {
        throw ValidationException(
          message: kTr.mapping_mappingScreen_noMappings_error,
        );
      }
      if (!conversionSessionService.hasUniqueColumnNames) {
        throw ValidationException(
          message: kTr.mapping_mappingScreen_duplicateColumn_error,
        );
      }
      if (saveProfileEnabled.value) {
        final name = profileNameController.text.trim();
        if (name.isEmpty) {
          throw ValidationException(
            message: kTr.mapping_profile_nameField_requiredError,
          );
        }
        if (mappingProfileService.profiles.any((p) => p.name == name)) {
          throw ValidationException(
            message: kTr.mapping_profile_duplicateName_error,
          );
        }
        await mappingProfileService.saveProfile(
          name: name,
          mappings: conversionSessionService.mappings.toList(),
        );
      }
      Get.toNamed(kRouteExport);
    });
  }
}
