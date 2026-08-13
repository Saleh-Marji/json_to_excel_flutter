import 'package:flutter/material.dart';

import '../../../constants/localizations.dart';
import '../models/field_mapping.dart';

class MappingListTile extends StatelessWidget {
  const MappingListTile({
    super.key,
    required this.mapping,
    required this.onEdit,
    required this.onRemove,
    this.dragHandle,
  });

  final FieldMapping mapping;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    final path = mapping.pathLabel.isEmpty
        ? t.mapping_mappingScreen_breadcrumbRoot
        : mapping.pathLabel;
    return ListTile(
      dense: true,
      leading: dragHandle,
      title: Text(mapping.columnName),
      subtitle: Text(path),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: t.common_edit,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: t.common_remove,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
