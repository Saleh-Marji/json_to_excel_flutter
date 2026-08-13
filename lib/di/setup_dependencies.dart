import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../constants/env_config.dart';
import '../features/conversion/repositories/json_file_repository.dart';
import '../features/conversion/repositories/mapping_profile_repository.dart';
import '../features/conversion/repositories/spreadsheet_writer_repository.dart';
import '../features/conversion/services/conversion_session_service.dart';
import '../features/conversion/services/export_job_service.dart';
import '../features/conversion/services/json_schema_service.dart';
import '../features/conversion/services/mapping_profile_service.dart';
import '../features/conversion/services/row_explode_service.dart';

/// Global dependency registration. Order is fixed by project rules.
void setupDependencies() {
  setupApiClient(
    baseUrl: EnvConfig.apiBaseUrl,
    enableLogging: EnvConfig.enableDebugLogging && !EnvConfig.isProduction,
  );
  Get.put(StorageService());
  Get.put(MappingProfileRepository());
  Get.put(JsonFileRepository());
  Get.put(SpreadsheetWriterRepository());
  Get.put(JsonSchemaService());
  Get.put(RowExplodeService());
  Get.put(ConversionSessionService());
  Get.put(MappingProfileService());
  Get.put(ExportJobService());
  mappingProfileService.load();
}
