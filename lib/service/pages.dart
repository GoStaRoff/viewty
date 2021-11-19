// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewty/service/dynamic_link_api.dart';
import 'package:viewty/views/home/home_binding.dart';
import 'package:viewty/views/home/home_screen.dart';
import 'package:viewty/views/loading_screen.dart';

String kINITIALROUTE = LoadingScreen.id;

GetPage kUKNOWNROUTE = GetPage(
  name: HomeView.id,
  page: () => HomeView(),
  binding: HomeBinding(),
);
GetPage kINTERNET_ERROR =
    GetPage(name: "/internet_error", page: () => Container());

List<GetPage<dynamic>> kPAGES = [
  GetPage(
    name: HomeView.id,
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(name: LoadingScreen.id, page: () => const LoadingScreen()),
];

class NotFoundBinding extends Bindings {
  @override
  void dependencies() {
    DynamicLinksApi.handleDynamicLink();
  }
}
