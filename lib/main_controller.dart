import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:viewty/service/dynamic_link_api.dart';
import 'package:viewty/views/home/home_screen.dart';

class MainController extends GetxController {
  String deviceID = "";
  String mobileModel = "";
  String systemVersion = "";
  String timeZone = "";
  String countryCode = "";
  bool wasInstalled = false;
  GetStorage box = GetStorage();

  @override
  void onInit() {
    getId();
    super.onInit();
  }

  getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      mobileModel = iosDeviceInfo.name!;
      systemVersion =
          iosDeviceInfo.systemName! + "v" + iosDeviceInfo.systemVersion!;
      timeZone = DateTime.now().timeZoneName;
      countryCode = Get.deviceLocale.toString().toUpperCase();
      deviceID = iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      mobileModel =
          androidDeviceInfo.manufacturer! + " " + androidDeviceInfo.model!;
      systemVersion = "Android " + androidDeviceInfo.version.release!;
      timeZone = DateTime.now().timeZoneName;
      countryCode = Get.deviceLocale.toString().toUpperCase();
      deviceID = androidDeviceInfo.androidId!; // unique ID on Android
    }
    wasInstalled = await box.read("wasInstalled") != null;
    Get.offAllNamed(HomeView.id);
  }
}
