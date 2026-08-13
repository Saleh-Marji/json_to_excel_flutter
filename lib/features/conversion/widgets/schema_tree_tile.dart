import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/localizations.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/json_value_type.dart';
import '../models/path_segment.dart';
import '../models/schema_node.dart';
import '../services/conversion_session_service.dart';

String jsonValueTypeLabel(AppLocalizations t, JsonValueType type) {
  switch (type) {
    case JsonValueType.string:
      return t.mapping_type_string;
    case JsonValueType.number:
      return t.mapping_type_number;
    case JsonValueType.boolean:
      return t.mapping_type_boolean;
    case JsonValueType.object:
      return t.mapping_type_object;
    case JsonValueType.array:
      return t.mapping_type_array;
  }
}

/// Recursive indented tree row for one schema node.
class SchemaTreeTile extends StatelessWidget {
  const SchemaTreeTile({
    super.key,
    required this.node,
    required this.path,
    required this.onSelectLeaf,
    this.depth = 0,
  });

  final SchemaNode node;
  final List<PathSegment> path;
  final void Function(List<PathSegment> path) onSelectLeaf;
  final int depth;

  static const double _childIndent = 16;

  @override
  Widget build(BuildContext context) {
    if (node.isLeaf) {
      return _LeafTile(
        node: node,
        path: path,
        onSelectLeaf: onSelectLeaf,
      );
    }
    return _ObjectTile(
      node: node,
      path: path,
      depth: depth,
      onSelectLeaf: onSelectLeaf,
    );
  }
}

class _ObjectTile extends StatelessWidget {
  const _ObjectTile({
    required this.node,
    required this.path,
    required this.depth,
    required this.onSelectLeaf,
  });

  final SchemaNode node;
  final List<PathSegment> path;
  final int depth;
  final void Function(List<PathSegment> path) onSelectLeaf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = kTrc(context);
    final label = node.name.isEmpty ? t.mapping_mappingScreen_breadcrumbRoot : node.name;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          initiallyExpanded: true,
          maintainState: true,
          leading: Icon(
            node.isArray ? Icons.data_array : Icons.folder_outlined,
            color: theme.colorScheme.primary,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(label, overflow: TextOverflow.ellipsis),
              ),
              _TypeBadge(label: jsonValueTypeLabel(t, node.valueType)),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          children: [
            if (node.children.isEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  t.mapping_mappingScreen_empty_description,
                  style: theme.textTheme.bodySmall,
                ),
              )
            else
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.45),
                      width: 2,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: SchemaTreeTile._childIndent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final child in node.children)
                        SchemaTreeTile(
                          node: child,
                          path: [...path, child.segment],
                          depth: depth + 1,
                          onSelectLeaf: onSelectLeaf,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LeafTile extends StatelessWidget {
  const _LeafTile({
    required this.node,
    required this.path,
    required this.onSelectLeaf,
  });

  final SchemaNode node;
  final List<PathSegment> path;
  final void Function(List<PathSegment> path) onSelectLeaf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = kTrc(context);
    final label = node.name.isEmpty
        ? t.mapping_mappingScreen_selectValue_button
        : node.name;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Obx(() {
        conversionSessionService.mappings.toList();
        final selected = conversionSessionService.isPathMapped(path);
        final mapping = conversionSessionService.mappingFor(path);
        final background = selected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface;
        return Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          color: background,
          child: ListTile(
            leading: Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(label, overflow: TextOverflow.ellipsis),
                ),
                _TypeBadge(label: jsonValueTypeLabel(t, node.valueType)),
              ],
            ),
            subtitle: _leafSubtitle(
              context,
              example: node.example,
              columnName: mapping?.columnName,
            ),
            isThreeLine: node.example != null &&
                node.example!.trim().isNotEmpty &&
                mapping != null,
            onTap: () => onSelectLeaf(path),
          ),
        );
      }),
    );
  }

  Widget? _leafSubtitle(
    BuildContext context, {
    required String? example,
    required String? columnName,
  }) {
    final t = kTrc(context);
    final theme = Theme.of(context);
    final hasExample = example != null && example.trim().isNotEmpty;
    final hasColumn = columnName != null && columnName.isNotEmpty;
    if (!hasExample && !hasColumn) {
      return null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasExample)
          Text(
            t.mapping_mappingScreen_example(example),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (hasColumn)
          Text(
            columnName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
