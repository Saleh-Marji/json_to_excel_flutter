import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/routes.dart';
import 'constants/theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_pages.dart';

class JsonToExcelApp extends StatelessWidget {
  const JsonToExcelApp({super.key, this.initialRoute});

  /// When set (e.g. in widget tests), skips the default home route.
  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: lookupAppLocalizations(const Locale('en')).app_title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute ?? kRouteHome,
      getPages: getAppPages(),
      unknownRoute: unknownRoutePage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
