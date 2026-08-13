import 'dart:async';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../models/export_progress.dart';
import 'conversion_session_service.dart';
import 'export_isolate.dart';

ExportJobService get exportJobService => Get.find<ExportJobService>();

class ExportJobService extends AppService {
  final progress = const ExportProgress.idle().obs;

  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<void> start() {
    return runVoid(() async {
      await _cancelRunning();
      final session = conversionSessionService;
      final json = session.parsedJson.value;
      final dest = session.destinationPath.value;
      if (json == null) {
        throw const ValidationException(
          message: 'No JSON file is loaded. Start from the home screen.',
        );
      }
      if (session.mappings.isEmpty) {
        throw const ValidationException(
          message: 'Go back and select at least one column.',
        );
      }
      if (dest == null || dest.isEmpty) {
        throw const ValidationException(
          message: 'Choose a destination file first.',
        );
      }

      progress.value = const ExportProgress(
        phase: ExportPhase.exploding,
        current: 0,
        total: 1,
      );

      final receivePort = ReceivePort();
      _receivePort = receivePort;
      final done = Completer<void>();

      receivePort.listen((message) {
        if (message is! Map) {
          return;
        }
        final type = message['type'] as String?;
        switch (type) {
          case 'progress':
            final phaseName = message['phase'] as String? ?? 'exploding';
            progress.value = ExportProgress(
              phase: phaseName == 'writing'
                  ? ExportPhase.writing
                  : ExportPhase.exploding,
              current: message['current'] as int? ?? 0,
              total: message['total'] as int? ?? 0,
            );
          case 'done':
            progress.value = ExportProgress(
              phase: ExportPhase.done,
              current: 1,
              total: 1,
              outputPath: message['path'] as String? ?? dest,
            );
            if (!done.isCompleted) {
              done.complete();
            }
          case 'error':
            final errorMessage =
                message['message'] as String? ?? 'Export failed.';
            progress.value = ExportProgress(
              phase: ExportPhase.error,
              errorMessage: errorMessage,
            );
            if (!done.isCompleted) {
              done.completeError(
                UnknownException(message: errorMessage),
              );
            }
        }
      });

      try {
        _isolate = await Isolate.spawn(
          exportIsolateMain,
          <String, dynamic>{
            'sendPort': receivePort.sendPort,
            'json': json,
            'mappings': session.mappings.map((m) => m.toIsolateMap()).toList(),
            'format': session.format.value.name,
            'path': dest,
          },
        );
        await done.future;
      } finally {
        await _cancelRunning(resetProgress: false);
      }
    });
  }

  Future<void> reset() async {
    await _cancelRunning();
    progress.value = const ExportProgress.idle();
  }

  Future<void> _cancelRunning({bool resetProgress = true}) async {
    _receivePort?.close();
    _receivePort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    if (resetProgress) {
      progress.value = const ExportProgress.idle();
    }
  }
}
