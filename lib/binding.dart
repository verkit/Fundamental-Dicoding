import 'package:get/get.dart';
import 'package:restaurant/controller.dart';
import 'package:restaurant/utils/connection.dart';

/// Binding
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConnectionController(), fenix: true);
    Get.lazyPut(() => AppController(), fenix: true);
  }
}

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteController());
  }
}

class RestaurantBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantController>(() => RestaurantController());
  }
}
