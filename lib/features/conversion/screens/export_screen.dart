import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_error_widget.dart';
import '../../../constants/localizations.dart';
import '../models/export_format.dart';
import '../models/export_progress.dart';
import '../screen_controllers/export_controller.dart';
import '../services/conversion_session_service.dart';
import '../services/export_job_service.dart';
import '../widgets/export_progress_body.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    final controller = exportController;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.export_exportScreen_title),
        centerTitle: Platform.isIOS,
      ),
      body: Obx(() {
        final progress = exportJobService.progress.value;
        if (controller.isLoading || progress.isRunning) {
          return ExportProgressBody(progress: progress);
        }
        if (progress.phase == ExportPhase.done &&
            progress.outputPath != null) {
          return _DoneBody(
            path: progress.outputPath!,
            onOpenFolder: controller.openFolder,
            onStartOver: controller.startOver,
          );
        }
        if (progress.phase == ExportPhase.error) {
          return AppErrorWidget(
            message: progress.errorMessage ?? t.common_error,
            onRetry: controller.retry,
            retryLabel: t.common_retry,
          );
        }
        return _SetupBody(controller: controller);
      }),
    );
  }
}

class _SetupBody extends StatelessWidget {
  const _SetupBody({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.export_exportScreen_format_label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Obx(() {
                final group = conversionSessionService.format.value;
                return RadioGroup<ExportFormat>(
                  groupValue: group,
                  onChanged: controller.selectFormat,
                  child: Column(
                    children: [
                      RadioListTile<ExportFormat>(
                        title: Text(t.export_exportScreen_formatXlsx_label),
                        value: ExportFormat.xlsx,
                      ),
                      RadioListTile<ExportFormat>(
                        title: Text(t.export_exportScreen_formatCsv_label),
                        value: ExportFormat.csv,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Text(
                t.export_exportScreen_destination_label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Obx(() {
                final dest = conversionSessionService.destinationPath.value;
                return Text(
                  dest == null || dest.isEmpty
                      ? t.export_exportScreen_destinationEmpty_hint
                      : dest,
                );
              }),
              const SizedBox(height: 12),
              AppButton(
                label: t.export_exportScreen_chooseDestination_button,
                onPressed: controller.pickDestination,
              ),
              const Spacer(),
              AppButton(
                label: t.export_exportScreen_start_button,
                onPressed: controller.startExport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoneBody extends StatelessWidget {
  const _DoneBody({
    required this.path,
    required this.onOpenFolder,
    required this.onStartOver,
  });

  final String path;
  final VoidCallback onOpenFolder;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                t.export_exportScreen_done_title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                t.export_exportScreen_done_message(path),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: t.export_exportScreen_openFolder_button,
                onPressed: onOpenFolder,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onStartOver,
                child: Text(t.export_exportScreen_startOver_button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
