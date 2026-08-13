import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/features/conversion/models/export_progress.dart';
import 'package:json_to_excel/features/conversion/models/field_mapping.dart';
import 'package:json_to_excel/features/conversion/models/json_value_type.dart';
import 'package:json_to_excel/features/conversion/models/path_segment.dart';
import 'package:json_to_excel/features/conversion/screen_controllers/export_controller.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/export_job_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';
import 'package:json_to_excel/l10n/generated/app_localizations.dart';

void main() {
  late ExportController sut;

  setUp(() {
    Get.testMode = true;
    Get.put(JsonSchemaService());
    Get.put(ConversionSessionService());
    Get.put(ExportJobService());
    sut = ExportController();
    Get.put(sut);
  });

  tearDown(Get.reset);

  testWidgets('startExport without a destination does not set errorMessage', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SizedBox(),
      ),
    );
    await tester.pumpAndSettle();
    await conversionSessionService.loadFromFile(
      path: 't.json',
      json: {'name': 'Alice'},
    );
    conversionSessionService.upsertMapping(
      const FieldMapping(
        path: [PathSegment(key: 'name', type: JsonValueType.string)],
        columnName: 'Name',
      ),
    );

    await sut.startExport();
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(sut.errorMessage, isNull);
    expect(exportJobService.progress.value.phase, ExportPhase.idle);
  });

  test('retry without a destination resets the job and stays idle', () async {
    exportJobService.progress.value = const ExportProgress(
      phase: ExportPhase.error,
      errorMessage: 'Choose a destination file first.',
    );

    await sut.retry();

    expect(sut.errorMessage, isNull);
    expect(exportJobService.progress.value.phase, ExportPhase.idle);
  });
}
