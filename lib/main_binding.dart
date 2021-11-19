import 'package:get/get.dart';
import 'package:viewty/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.snackbar("Hello", "world");
    Get.put<MainController>(MainController());
  }
}
