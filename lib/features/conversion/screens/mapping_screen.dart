import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_empty_state.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../constants/localizations.dart';
import '../models/field_mapping.dart';
import '../screen_controllers/mapping_controller.dart';
import '../services/conversion_session_service.dart';
import '../services/mapping_profile_service.dart';
import '../widgets/mapping_list_tile.dart';
import '../widgets/schema_tree_tile.dart';

class MappingScreen extends StatelessWidget {
  const MappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    final controller = mappingController;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.mapping_mappingScreen_title),
        centerTitle: Platform.isIOS,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.mapping_mappingScreen_tree_hint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                conversionSessionService.schema.value;
                final schema = conversionSessionService.schema.value;
                if (schema == null ||
                    (!schema.isLeaf && schema.children.isEmpty)) {
                  return AppEmptyState(
                    title: t.mapping_mappingScreen_empty_title,
                    description: t.mapping_mappingScreen_empty_description,
                  );
                }
                if (schema.isLeaf) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SchemaTreeTile(
                        node: schema,
                        path: const [],
                        onSelectLeaf: controller.selectLeaf,
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: schema.children.length,
                  itemBuilder: (context, index) {
                    final child = schema.children[index];
                    return SchemaTreeTile(
                      node: child,
                      path: [child.segment],
                      onSelectLeaf: controller.selectLeaf,
                    );
                  },
                );
              }),
            ),
            const Divider(),
            Obx(() {
              final profiles = mappingProfileService.profiles.toList();
              if (profiles.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.mapping_profile_saved_title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final profile in profiles)
                        ActionChip(
                          label: Text(profile.name),
                          onPressed: () => controller.applyProfile(profile),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(t.mapping_profile_saveSwitch_label),
                    value: controller.saveProfileEnabled.value,
                    onChanged: controller.setSaveProfileEnabled,
                  ),
                  if (controller.saveProfileEnabled.value) ...[
                    AppTextField(
                      label: t.mapping_profile_nameField_label,
                      hint: t.mapping_profile_nameField_hint,
                      controller: controller.profileNameController,
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            }),
            Text(
              t.mapping_mappingScreen_selected_title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                final mappings = conversionSessionService.mappings.toList();
                if (mappings.isEmpty) {
                  return Center(
                    child: Text(t.mapping_mappingScreen_selected_empty),
                  );
                }
                return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: mappings.length,
                  onReorder: controller.reorderMappings,
                  itemBuilder: (context, index) {
                    final FieldMapping mapping = mappings[index];
                    return MappingListTile(
                      key: ValueKey(mapping.pathKey),
                      mapping: mapping,
                      dragHandle: ReorderableDragStartListener(
                        index: index,
                        child: Tooltip(
                          message: t.mapping_mappingScreen_reorder_tooltip,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                      ),
                      onEdit: () => controller.editMapping(mapping),
                      onRemove: () => controller.removeMapping(mapping),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final enabled = conversionSessionService.mappings.isNotEmpty;
              return AppButton(
                label: t.mapping_mappingScreen_continue_button,
                onPressed: enabled ? controller.continueToExport : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
