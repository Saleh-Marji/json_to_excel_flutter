import 'dart:isolate';

import '../models/export_format.dart';
import '../models/field_mapping.dart';
import '../repositories/spreadsheet_writer_repository.dart';
import 'row_explode_service.dart';

/// Isolate entry for exploding JSON and writing xlsx/csv with progress messages.
@pragma('vm:entry-point')
void exportIsolateMain(Map<String, dynamic> message) {
  _runExport(message);
}

Future<void> _runExport(Map<String, dynamic> message) async {
  final sendPort = message['sendPort'] as SendPort;
  try {
    final json = message['json'];
    final rawMappings = message['mappings'] as List<dynamic>;
    final mappings = rawMappings
        .map((e) => FieldMapping.fromIsolateMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
    final format = ExportFormat.values.byName(message['format'] as String);
    final destPath = message['path'] as String;

    final explode = RowExplodeService();
    final writer = SpreadsheetWriterRepository();

    sendPort.send({
      'type': 'progress',
      'phase': 'exploding',
      'current': 0,
      'total': 1,
    });

    final rows = explode.explode(
      json: json,
      mappings: mappings,
      onRootProgress: (current, total) {
        sendPort.send({
          'type': 'progress',
          'phase': 'exploding',
          'current': current,
          'total': total <= 0 ? 1 : total,
        });
      },
    );
    final columns = mappings.map((m) => m.columnName).toList();

    sendPort.send({
      'type': 'progress',
      'phase': 'writing',
      'current': 0,
      'total': rows.isEmpty ? 1 : rows.length,
    });

    await writer.write(
      path: destPath,
      format: format,
      columns: columns,
      rows: rows,
      onProgress: (current, total) {
        sendPort.send({
          'type': 'progress',
          'phase': 'writing',
          'current': current,
          'total': total <= 0 ? 1 : total,
        });
      },
    );

    sendPort.send({
      'type': 'done',
      'path': destPath,
    });
  } catch (e) {
    sendPort.send({
      'type': 'error',
      'message': e.toString(),
    });
  }
}
