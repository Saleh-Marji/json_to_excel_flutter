/// Supported spreadsheet output formats.
enum ExportFormat {
  xlsx,
  csv,
}

extension ExportFormatX on ExportFormat {
  String get fileExtension {
    switch (this) {
      case ExportFormat.xlsx:
        return 'xlsx';
      case ExportFormat.csv:
        return 'csv';
    }
  }

  String get suggestedFileName => 'export.$fileExtension';
}
