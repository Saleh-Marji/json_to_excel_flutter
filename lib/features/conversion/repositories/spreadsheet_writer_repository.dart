import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/export_format.dart';

SpreadsheetWriterRepository get spreadsheetWriterRepository =>
    Get.find<SpreadsheetWriterRepository>();

class SpreadsheetWriterRepository extends AppRepository {
  Future<String?> pickSavePath({
    required ExportFormat format,
    required String suggestedName,
  }) {
    return execute(() async {
      return FilePicker.platform.saveFile(
        fileName: suggestedName,
        type: FileType.custom,
        allowedExtensions: [format.fileExtension],
      );
    });
  }

  Future<void> write({
    required String path,
    required ExportFormat format,
    required List<String> columns,
    required List<List<String>> rows,
    void Function(int current, int total)? onProgress,
  }) {
    return execute(() async {
      switch (format) {
        case ExportFormat.xlsx:
          await _writeXlsx(
            path: path,
            columns: columns,
            rows: rows,
            onProgress: onProgress,
          );
        case ExportFormat.csv:
          await _writeCsv(
            path: path,
            columns: columns,
            rows: rows,
            onProgress: onProgress,
          );
      }
    });
  }

  Future<void> revealInFileManager(String path) {
    return execute(() async {
      if (Platform.isWindows) {
        await Process.run('explorer', [
          '/select,',
          path.replaceAll('/', '\\'),
        ]);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', path]);
      } else {
        await Process.run('xdg-open', [p.dirname(path)]);
      }
    });
  }

  Future<void> _writeXlsx({
    required String path,
    required List<String> columns,
    required List<List<String>> rows,
    void Function(int current, int total)? onProgress,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = excel.tables.keys.first;
    final sheet = excel[sheetName];
    sheet.appendRow(columns.map(TextCellValue.new).toList());
    final total = rows.length;
    for (var i = 0; i < rows.length; i++) {
      sheet.appendRow(rows[i].map(TextCellValue.new).toList());
      onProgress?.call(i + 1, total);
    }
    final bytes = excel.encode();
    if (bytes == null) {
      throw const CacheException(message: 'Failed to encode the Excel file.');
    }
    try {
      await File(path).writeAsBytes(bytes, flush: true);
    } on FileSystemException catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to write the Excel file.',
        details: e.message,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _writeCsv({
    required String path,
    required List<String> columns,
    required List<List<String>> rows,
    void Function(int current, int total)? onProgress,
  }) async {
    final converter = const ListToCsvConverter();
    final buffer = StringBuffer('\uFEFF');
    converter.convertSingleRow(buffer, columns, returnString: false);
    final total = rows.length;
    if (total == 0) {
      onProgress?.call(0, 0);
    }
    for (var i = 0; i < rows.length; i++) {
      buffer.write(converter.eol);
      converter.convertSingleRow(buffer, rows[i], returnString: false);
      onProgress?.call(i + 1, total);
    }
    try {
      await File(path).writeAsString(buffer.toString(), flush: true);
    } on FileSystemException catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to write the CSV file.',
        details: e.message,
        stackTrace: stackTrace,
      );
    }
  }
}
