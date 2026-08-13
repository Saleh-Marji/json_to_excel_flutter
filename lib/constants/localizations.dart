import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../l10n/generated/app_localizations.dart';

/// Localizations with explicit [BuildContext].
AppLocalizations kTrc(BuildContext context) => AppLocalizations.of(context);

/// Localizations using GetX context (after [GetMaterialApp] is built).
AppLocalizations get kTr => kTrc(Get.context!);
