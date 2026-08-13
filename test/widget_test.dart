import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:json_to_excel/common/widgets/app_button.dart';
import 'package:json_to_excel/features/conversion/screen_controllers/home_controller.dart';
import 'package:json_to_excel/features/conversion/screens/home_screen.dart';
import 'package:json_to_excel/features/conversion/services/conversion_session_service.dart';
import 'package:json_to_excel/features/conversion/services/json_schema_service.dart';
import 'package:json_to_excel/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    Get.put(JsonSchemaService());
    Get.put(ConversionSessionService());
    Get.put(HomeController());
  });

  tearDown(Get.reset);

  testWidgets('home screen shows the pick-file button', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppButton), findsOneWidget);
  });
}
