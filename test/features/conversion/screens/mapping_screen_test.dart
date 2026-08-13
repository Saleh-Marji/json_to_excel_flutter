import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/common/widgets/app_text_field.dart';
import 'package:json_to_excel/features/conversion/models/mapping_profile.dart';
import 'package:json_to_excel/features/conversion/repositories/mapping_profile_repository.dart';
import 'package:json_to_excel/features/conversion/screen_controllers/mapping_controller.dart';
import 'package:json_to_excel/features/conversion/screens/mapping_screen.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';
import 'package:json_to_excel/features/conversion/services/mapping_profile_service.dart';
import 'package:json_to_excel/l10n/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockMappingProfileRepository extends Mock
    implements MappingProfileRepository {}

void main() {
  late MappingProfileService profiles;

  setUp(() {
    Get.testMode = true;
    final repo = MockMappingProfileRepository();
    when(() => repo.loadAll()).thenAnswer((_) async => []);
    Get.put<MappingProfileRepository>(repo);
    Get.put(JsonSchemaService());
    Get.put(ConversionSessionService());
    profiles = MappingProfileService();
    Get.put(profiles);
    Get.put(MappingController());
  });

  tearDown(Get.reset);

  testWidgets('shows profile chips and a name field when save is on', (
    tester,
  ) async {
    await conversionSessionService.loadFromFile(
      path: 't.json',
      json: {'name': 'Alice'},
    );
    profiles.profiles.add(
      const MappingProfile(name: 'Orders', mappings: []),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MappingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Orders'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byType(AppTextField), findsNothing);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(find.byType(AppTextField), findsOneWidget);
  });
}
