import 'package:get/get.dart';
import 'package:rakta_web/controller/home_controller.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
