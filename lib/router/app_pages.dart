import 'package:get/get.dart';

import '../constants/routes.dart';
import '../features/conversion/screen_controllers/export_controller.dart';
import '../features/conversion/screen_controllers/home_controller.dart';
import '../features/conversion/screen_controllers/mapping_controller.dart';
import '../features/conversion/screens/export_screen.dart';
import '../features/conversion/screens/home_screen.dart';
import '../features/conversion/screens/mapping_screen.dart';
import '../features/unknown_route/screen_controllers/unknown_route_controller.dart';
import '../features/unknown_route/screens/unknown_route_screen.dart';

List<GetPage<dynamic>> getAppPages() {
  return [
    GetPage(
      name: kRouteHome,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(HomeController.new);
      }),
    ),
    GetPage(
      name: kRouteMapping,
      page: () => const MappingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(MappingController.new);
      }),
    ),
    GetPage(
      name: kRouteExport,
      page: () => const ExportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(ExportController.new);
      }),
    ),
  ];
}

GetPage<dynamic> unknownRoutePage() {
  return GetPage(
    name: kRouteUnknown,
    page: () => const UnknownRouteScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut(UnknownRouteController.new);
    }),
  );
}
