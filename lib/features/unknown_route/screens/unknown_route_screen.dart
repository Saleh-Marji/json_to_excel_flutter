import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../../common/widgets/app_button.dart';
import '../../../constants/localizations.dart';
import '../screen_controllers/unknown_route_controller.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = kTrc(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.nav_unknownScreen_title),
        centerTitle: Platform.isIOS,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.nav_unknownScreen_body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: t.nav_unknownScreen_goHome_button,
              onPressed: unknownRouteController.goHome,
            ),
          ],
        ),
      ),
    );
  }
}
