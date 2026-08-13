import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

import '../../../constants/routes.dart';

UnknownRouteController get unknownRouteController =>
    Get.find<UnknownRouteController>();

class UnknownRouteController extends AppScreenController {
  void goHome() {
    Get.offAllNamed(kRouteHome);
  }
}
