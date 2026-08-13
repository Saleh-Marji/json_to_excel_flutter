import 'package:flutter/material.dart';

import '../../../common/widgets/app_loading_indicator.dart';
import '../../../constants/localizations.dart';
import '../models/export_progress.dart';

class ExportProgressBody extends StatelessWidget {
  const ExportProgressBody({
    super.key,
    required this.progress,
  });

  final ExportProgress progress;

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    final message = switch (progress.phase) {
      ExportPhase.writing => t.export_exportScreen_progressWriting(
          progress.current,
          progress.total,
        ),
      _ => t.export_exportScreen_progressExploding(
          progress.current,
          progress.total,
        ),
    };
    return AppLoadingIndicator(
      message: message,
      progress: progress.fraction,
    );
  }
}
