import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../../../constants/localizations.dart';
import '../../../constants/routes.dart';
import '../models/export_format.dart';
import '../models/export_progress.dart';
import '../repositories/spreadsheet_writer_repository.dart';
import '../services/conversion_session_service.dart';
import '../services/export_job_service.dart';

ExportController get exportController => Get.find<ExportController>();

class ExportController extends AppScreenController {
  ExportProgress get jobProgress => exportJobService.progress.value;

  void selectFormat(ExportFormat? value) {
    if (value == null) {
      return;
    }
    conversionSessionService.selectFormat(value);
  }

  Future<void> pickDestination() {
    return performSilent(() async {
      final path = await spreadsheetWriterRepository.pickSavePath(
        format: conversionSessionService.format.value,
        suggestedName: conversionSessionService.suggestedFileName(),
      );
      if (path == null) {
        return;
      }
      conversionSessionService.destinationPath.value = path;
    });
  }

  Future<void> startExport() {
    return performSilent(() async {
      final session = conversionSessionService;
      if (session.parsedJson.value == null) {
        throw ValidationException(
          message: kTr.export_exportScreen_needJson_error,
        );
      }
      if (session.mappings.isEmpty) {
        throw ValidationException(
          message: kTr.export_exportScreen_needMappings_error,
        );
      }
      if (session.destinationPath.value == null ||
          session.destinationPath.value!.isEmpty) {
        throw ValidationException(
          message: kTr.export_exportScreen_needDestination_error,
        );
      }
      await exportJobService.start();
    });
  }

  Future<void> openFolder() {
    return performSilent(() async {
      final path = exportJobService.progress.value.outputPath ??
          conversionSessionService.destinationPath.value;
      if (path == null) {
        return;
      }
      await spreadsheetWriterRepository.revealInFileManager(path);
    });
  }

  Future<void> startOver() async {
    await exportJobService.reset();
    conversionSessionService.reset();
    Get.offAllNamed(kRouteHome);
  }

  @override
  Future<void> retry() async {
    await exportJobService.reset();
    final dest = conversionSessionService.destinationPath.value;
    if (dest == null || dest.isEmpty) {
      return;
    }
    await startExport();
  }
}
