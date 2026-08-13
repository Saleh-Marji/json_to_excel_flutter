import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../../../constants/routes.dart';
import '../repositories/json_file_repository.dart';
import '../services/conversion_session_service.dart';

HomeController get homeController => Get.find<HomeController>();

class HomeController extends AppScreenController {
  String? get selectedFileName {
    final path = conversionSessionService.sourcePath.value;
    if (path == null || path.isEmpty) {
      return null;
    }
    return p.basename(path);
  }

  Future<void> pickFile() {
    return perform(() async {
      final path = await jsonFileRepository.pickJsonPath();
      if (path == null) {
        return;
      }
      final json = await jsonFileRepository.parseFile(path);
      await conversionSessionService.loadFromFile(path: path, json: json);
      Get.toNamed(kRouteMapping);
    });
  }
}
