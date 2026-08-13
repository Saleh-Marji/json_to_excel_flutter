// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'JSON to Excel';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_back => 'Back';

  @override
  String get common_continue => 'Continue';

  @override
  String get common_error => 'Error';

  @override
  String get common_remove => 'Remove';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_save => 'Save';

  @override
  String get nav_unknownScreen_title => 'Page not found';

  @override
  String get nav_unknownScreen_body =>
      'This screen does not exist. Return home to pick a JSON file.';

  @override
  String get nav_unknownScreen_goHome_button => 'Go home';

  @override
  String get import_homeScreen_title => 'JSON to Excel';

  @override
  String get import_homeScreen_description =>
      'Select a JSON file. Nested lists are merged into one object so you can pick the leaf fields to export.';

  @override
  String get import_homeScreen_selectFile_button => 'Select JSON file';

  @override
  String get import_homeScreen_loading_message => 'Reading JSON file…';

  @override
  String import_homeScreen_selectedFile_label(String name) {
    return 'Selected: $name';
  }

  @override
  String get mapping_mappingScreen_title => 'Choose columns';

  @override
  String get mapping_mappingScreen_tree_hint =>
      'Expand objects to see nested fields. Tap a leaf field to add it as a column.';

  @override
  String get mapping_mappingScreen_breadcrumbRoot => 'Root';

  @override
  String get mapping_mappingScreen_empty_title => 'No fields here';

  @override
  String get mapping_mappingScreen_empty_description =>
      'This JSON has no keys to map.';

  @override
  String get mapping_mappingScreen_selected_title => 'Selected columns';

  @override
  String get mapping_mappingScreen_selected_empty =>
      'Select leaf fields to add Excel columns.';

  @override
  String get mapping_mappingScreen_continue_button => 'Continue';

  @override
  String get mapping_mappingScreen_selectValue_button => 'Select this value';

  @override
  String get mapping_mappingScreen_noMappings_error =>
      'Select at least one field.';

  @override
  String get mapping_mappingScreen_duplicateColumn_error =>
      'Column names must be unique.';

  @override
  String get mapping_mappingScreen_wasList_badge => 'list';

  @override
  String get mapping_mappingScreen_reorder_tooltip => 'Reorder';

  @override
  String get mapping_type_string => 'string';

  @override
  String get mapping_type_number => 'number';

  @override
  String get mapping_type_boolean => 'boolean';

  @override
  String get mapping_type_object => 'object';

  @override
  String get mapping_type_array => 'array';

  @override
  String mapping_mappingScreen_example(String value) {
    return 'e.g. $value';
  }

  @override
  String get mapping_profile_saved_title => 'Saved profiles';

  @override
  String get mapping_profile_saveSwitch_label => 'Save as profile';

  @override
  String get mapping_profile_nameField_label => 'Profile name';

  @override
  String get mapping_profile_nameField_hint => 'Must be unique';

  @override
  String get mapping_profile_nameField_requiredError => 'Enter a profile name.';

  @override
  String get mapping_profile_duplicateName_error =>
      'A profile with this name already exists.';

  @override
  String get mapping_columnDialog_title => 'Column name';

  @override
  String get mapping_columnDialog_label => 'Excel column name';

  @override
  String get mapping_columnDialog_hint => 'Name shown in the first row';

  @override
  String get mapping_columnDialog_requiredError => 'Enter a column name.';

  @override
  String get export_exportScreen_title => 'Export';

  @override
  String get export_exportScreen_format_label => 'Output format';

  @override
  String get export_exportScreen_formatXlsx_label => 'Excel (.xlsx)';

  @override
  String get export_exportScreen_formatCsv_label => 'CSV (.csv)';

  @override
  String get export_exportScreen_destination_label => 'Destination';

  @override
  String get export_exportScreen_destinationEmpty_hint =>
      'No file selected yet';

  @override
  String get export_exportScreen_chooseDestination_button =>
      'Choose destination';

  @override
  String get export_exportScreen_start_button => 'Start export';

  @override
  String export_exportScreen_progressExploding(int current, int total) {
    return 'Building rows ($current of $total)';
  }

  @override
  String export_exportScreen_progressWriting(int current, int total) {
    return 'Writing file ($current of $total)';
  }

  @override
  String get export_exportScreen_done_title => 'Export finished';

  @override
  String export_exportScreen_done_message(String path) {
    return 'Saved to $path';
  }

  @override
  String get export_exportScreen_openFolder_button => 'Open folder';

  @override
  String get export_exportScreen_startOver_button => 'Start over';

  @override
  String get export_exportScreen_needDestination_error =>
      'Choose a destination file first.';

  @override
  String get export_exportScreen_needMappings_error =>
      'Go back and select at least one column.';

  @override
  String get export_exportScreen_needJson_error =>
      'No JSON file is loaded. Start from the home screen.';
}
