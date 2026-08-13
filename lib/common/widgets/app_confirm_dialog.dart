import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog._({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  /// Shows a confirmation dialog. All strings should come from [kTr] at the call site.
  static Future<bool?> show({
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
  }) {
    return Get.dialog<bool>(
      AppConfirmDialog._(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
            onConfirm();
          },
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
