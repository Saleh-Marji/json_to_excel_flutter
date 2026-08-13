import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'JSON to Excel'**
  String get app_title;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get common_remove;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @nav_unknownScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get nav_unknownScreen_title;

  /// No description provided for @nav_unknownScreen_body.
  ///
  /// In en, this message translates to:
  /// **'This screen does not exist. Return home to pick a JSON file.'**
  String get nav_unknownScreen_body;

  /// No description provided for @nav_unknownScreen_goHome_button.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get nav_unknownScreen_goHome_button;

  /// No description provided for @import_homeScreen_title.
  ///
  /// In en, this message translates to:
  /// **'JSON to Excel'**
  String get import_homeScreen_title;

  /// No description provided for @import_homeScreen_description.
  ///
  /// In en, this message translates to:
  /// **'Select a JSON file. Nested lists are merged into one object so you can pick the leaf fields to export.'**
  String get import_homeScreen_description;

  /// No description provided for @import_homeScreen_selectFile_button.
  ///
  /// In en, this message translates to:
  /// **'Select JSON file'**
  String get import_homeScreen_selectFile_button;

  /// No description provided for @import_homeScreen_loading_message.
  ///
  /// In en, this message translates to:
  /// **'Reading JSON file…'**
  String get import_homeScreen_loading_message;

  /// No description provided for @import_homeScreen_selectedFile_label.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String import_homeScreen_selectedFile_label(String name);

  /// No description provided for @mapping_mappingScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Choose columns'**
  String get mapping_mappingScreen_title;

  /// No description provided for @mapping_mappingScreen_tree_hint.
  ///
  /// In en, this message translates to:
  /// **'Expand objects to see nested fields. Tap a leaf field to add it as a column.'**
  String get mapping_mappingScreen_tree_hint;

  /// No description provided for @mapping_mappingScreen_breadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get mapping_mappingScreen_breadcrumbRoot;

  /// No description provided for @mapping_mappingScreen_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No fields here'**
  String get mapping_mappingScreen_empty_title;

  /// No description provided for @mapping_mappingScreen_empty_description.
  ///
  /// In en, this message translates to:
  /// **'This JSON has no keys to map.'**
  String get mapping_mappingScreen_empty_description;

  /// No description provided for @mapping_mappingScreen_selected_title.
  ///
  /// In en, this message translates to:
  /// **'Selected columns'**
  String get mapping_mappingScreen_selected_title;

  /// No description provided for @mapping_mappingScreen_selected_empty.
  ///
  /// In en, this message translates to:
  /// **'Select leaf fields to add Excel columns.'**
  String get mapping_mappingScreen_selected_empty;

  /// No description provided for @mapping_mappingScreen_continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get mapping_mappingScreen_continue_button;

  /// No description provided for @mapping_mappingScreen_selectValue_button.
  ///
  /// In en, this message translates to:
  /// **'Select this value'**
  String get mapping_mappingScreen_selectValue_button;

  /// No description provided for @mapping_mappingScreen_noMappings_error.
  ///
  /// In en, this message translates to:
  /// **'Select at least one field.'**
  String get mapping_mappingScreen_noMappings_error;

  /// No description provided for @mapping_mappingScreen_duplicateColumn_error.
  ///
  /// In en, this message translates to:
  /// **'Column names must be unique.'**
  String get mapping_mappingScreen_duplicateColumn_error;

  /// No description provided for @mapping_mappingScreen_wasList_badge.
  ///
  /// In en, this message translates to:
  /// **'list'**
  String get mapping_mappingScreen_wasList_badge;

  /// No description provided for @mapping_mappingScreen_reorder_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get mapping_mappingScreen_reorder_tooltip;

  /// No description provided for @mapping_type_string.
  ///
  /// In en, this message translates to:
  /// **'string'**
  String get mapping_type_string;

  /// No description provided for @mapping_type_number.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get mapping_type_number;

  /// No description provided for @mapping_type_boolean.
  ///
  /// In en, this message translates to:
  /// **'boolean'**
  String get mapping_type_boolean;

  /// No description provided for @mapping_type_object.
  ///
  /// In en, this message translates to:
  /// **'object'**
  String get mapping_type_object;

  /// No description provided for @mapping_type_array.
  ///
  /// In en, this message translates to:
  /// **'array'**
  String get mapping_type_array;

  /// No description provided for @mapping_mappingScreen_example.
  ///
  /// In en, this message translates to:
  /// **'e.g. {value}'**
  String mapping_mappingScreen_example(String value);

  /// No description provided for @mapping_profile_saved_title.
  ///
  /// In en, this message translates to:
  /// **'Saved profiles'**
  String get mapping_profile_saved_title;

  /// No description provided for @mapping_profile_saveSwitch_label.
  ///
  /// In en, this message translates to:
  /// **'Save as profile'**
  String get mapping_profile_saveSwitch_label;

  /// No description provided for @mapping_profile_nameField_label.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get mapping_profile_nameField_label;

  /// No description provided for @mapping_profile_nameField_hint.
  ///
  /// In en, this message translates to:
  /// **'Must be unique'**
  String get mapping_profile_nameField_hint;

  /// No description provided for @mapping_profile_nameField_requiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a profile name.'**
  String get mapping_profile_nameField_requiredError;

  /// No description provided for @mapping_profile_duplicateName_error.
  ///
  /// In en, this message translates to:
  /// **'A profile with this name already exists.'**
  String get mapping_profile_duplicateName_error;

  /// No description provided for @mapping_columnDialog_title.
  ///
  /// In en, this message translates to:
  /// **'Column name'**
  String get mapping_columnDialog_title;

  /// No description provided for @mapping_columnDialog_label.
  ///
  /// In en, this message translates to:
  /// **'Excel column name'**
  String get mapping_columnDialog_label;

  /// No description provided for @mapping_columnDialog_hint.
  ///
  /// In en, this message translates to:
  /// **'Name shown in the first row'**
  String get mapping_columnDialog_hint;

  /// No description provided for @mapping_columnDialog_requiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a column name.'**
  String get mapping_columnDialog_requiredError;

  /// No description provided for @export_exportScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export_exportScreen_title;

  /// No description provided for @export_exportScreen_format_label.
  ///
  /// In en, this message translates to:
  /// **'Output format'**
  String get export_exportScreen_format_label;

  /// No description provided for @export_exportScreen_formatXlsx_label.
  ///
  /// In en, this message translates to:
  /// **'Excel (.xlsx)'**
  String get export_exportScreen_formatXlsx_label;

  /// No description provided for @export_exportScreen_formatCsv_label.
  ///
  /// In en, this message translates to:
  /// **'CSV (.csv)'**
  String get export_exportScreen_formatCsv_label;

  /// No description provided for @export_exportScreen_destination_label.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get export_exportScreen_destination_label;

  /// No description provided for @export_exportScreen_destinationEmpty_hint.
  ///
  /// In en, this message translates to:
  /// **'No file selected yet'**
  String get export_exportScreen_destinationEmpty_hint;

  /// No description provided for @export_exportScreen_chooseDestination_button.
  ///
  /// In en, this message translates to:
  /// **'Choose destination'**
  String get export_exportScreen_chooseDestination_button;

  /// No description provided for @export_exportScreen_start_button.
  ///
  /// In en, this message translates to:
  /// **'Start export'**
  String get export_exportScreen_start_button;

  /// No description provided for @export_exportScreen_progressExploding.
  ///
  /// In en, this message translates to:
  /// **'Building rows ({current} of {total})'**
  String export_exportScreen_progressExploding(int current, int total);

  /// No description provided for @export_exportScreen_progressWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing file ({current} of {total})'**
  String export_exportScreen_progressWriting(int current, int total);

  /// No description provided for @export_exportScreen_done_title.
  ///
  /// In en, this message translates to:
  /// **'Export finished'**
  String get export_exportScreen_done_title;

  /// No description provided for @export_exportScreen_done_message.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String export_exportScreen_done_message(String path);

  /// No description provided for @export_exportScreen_openFolder_button.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get export_exportScreen_openFolder_button;

  /// No description provided for @export_exportScreen_startOver_button.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get export_exportScreen_startOver_button;

  /// No description provided for @export_exportScreen_needDestination_error.
  ///
  /// In en, this message translates to:
  /// **'Choose a destination file first.'**
  String get export_exportScreen_needDestination_error;

  /// No description provided for @export_exportScreen_needMappings_error.
  ///
  /// In en, this message translates to:
  /// **'Go back and select at least one column.'**
  String get export_exportScreen_needMappings_error;

  /// No description provided for @export_exportScreen_needJson_error.
  ///
  /// In en, this message translates to:
  /// **'No JSON file is loaded. Start from the home screen.'**
  String get export_exportScreen_needJson_error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
