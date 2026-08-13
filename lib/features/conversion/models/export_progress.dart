/// Phases of a JSON-to-spreadsheet export job.
enum ExportPhase {
  idle,
  exploding,
  writing,
  done,
  error,
}

/// Progress reported by [ExportJobService] to the UI.
class ExportProgress {
  const ExportProgress({
    required this.phase,
    this.current = 0,
    this.total = 0,
    this.outputPath,
    this.errorMessage,
  });

  const ExportProgress.idle() : this(phase: ExportPhase.idle);

  final ExportPhase phase;
  final int current;
  final int total;
  final String? outputPath;
  final String? errorMessage;

  bool get isRunning =>
      phase == ExportPhase.exploding || phase == ExportPhase.writing;

  double? get fraction {
    if (total <= 0) {
      return null;
    }
    return (current / total).clamp(0, 1);
  }

  ExportProgress copyWith({
    ExportPhase? phase,
    int? current,
    int? total,
    String? outputPath,
    String? errorMessage,
  }) {
    return ExportProgress(
      phase: phase ?? this.phase,
      current: current ?? this.current,
      total: total ?? this.total,
      outputPath: outputPath ?? this.outputPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
