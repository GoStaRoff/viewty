import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:viewty/main_binding.dart';
import 'package:viewty/service/dynamic_link_api.dart';
import 'package:viewty/service/ori_translations.dart';
import 'package:viewty/service/pages.dart';

void main() async {
  await GetStorage.init();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white));
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(GetMaterialApp(
    translations: OriTranslations(),
    locale: OriTranslations.languages["russian"]!,
    initialBinding: MainBinding(),
    initialRoute: kINITIALROUTE,
    unknownRoute: kUKNOWNROUTE,
    getPages: kPAGES,
  ));
}
