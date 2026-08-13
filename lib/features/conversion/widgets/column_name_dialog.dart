import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_text_field.dart';
import '../../../constants/localizations.dart';

class ColumnNameDialog extends StatefulWidget {
  const ColumnNameDialog({
    super.key,
    required this.initialName,
  });

  final String initialName;

  static Future<String?> show({required String initialName}) {
    return Get.dialog<String>(
      ColumnNameDialog(initialName: initialName),
    );
  }

  @override
  State<ColumnNameDialog> createState() => _ColumnNameDialogState();
}

class _ColumnNameDialogState extends State<ColumnNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Get.back(result: _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    return AlertDialog(
      title: Text(t.mapping_columnDialog_title),
      content: Form(
        key: _formKey,
        child: AppTextField(
          label: t.mapping_columnDialog_label,
          hint: t.mapping_columnDialog_hint,
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return t.mapping_columnDialog_requiredError;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(t.common_cancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(t.common_save),
        ),
      ],
    );
  }
}
