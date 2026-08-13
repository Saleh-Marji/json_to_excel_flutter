import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_error_widget.dart';
import '../../../common/widgets/app_loading_indicator.dart';
import '../../../constants/localizations.dart';
import '../screen_controllers/home_controller.dart';
import '../services/conversion_session_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    final controller = homeController;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.import_homeScreen_title),
        centerTitle: Platform.isIOS,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return AppLoadingIndicator(
            message: t.import_homeScreen_loading_message,
          );
        }
        if (controller.errorMessage != null) {
          return AppErrorWidget(
            message: controller.errorMessage!,
            onRetry: controller.pickFile,
            retryLabel: t.common_retry,
          );
        }
        final fileName = controller.selectedFileName;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.import_homeScreen_description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: t.import_homeScreen_selectFile_button,
                    onPressed: controller.pickFile,
                  ),
                  if (fileName != null) ...[
                    const SizedBox(height: 16),
                    Obx(() {
                      conversionSessionService.sourcePath.value;
                      return Text(
                        t.import_homeScreen_selectedFile_label(fileName),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
