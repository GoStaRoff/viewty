import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/instance_manager.dart';
import 'package:viewty/main_controller.dart';
import 'package:viewty/model/video_model.dart';

class ViewtyApi {
  MainController mainController = Get.find();
  var dio;
  static bool _launched = false;

  ViewtyApi() {
    print(
        "Viewty(v0.1;API1.0;${mainController.mobileModel};${mainController.systemVersion};${mainController.timeZone};${mainController.countryCode})");
    dio = Dio(
      BaseOptions(
        baseUrl: "http://viewty.ru/api/",
        headers: {
          "Content-Type": "application/json",
          "User-Agent": "Viewty(v0.1;API1.0;IPhone X;iOSv13;UTC3;RU)",
          // "User-Agent": "Viewty(v0.1;API1.0;${mainController.mobileModel};${mainController.systemVersion};${mainController.timeZone};${mainController.countryCode})",
          "Device-ID": mainController.deviceID,
        },
      ),
    );

    if (!mainController.wasInstalled) {
      _registration(Platform.isAndroid ? "PLAYMARKET" : "APPSTORE")
          .then((value) => mainController.box.write("wasInstalled", "true"));
    }
    if (!_launched) {
      _launch().then((value) => print(value.data));
      _launched = true;
    }
  }

  testRequest() async {}

  //--------------------------Пользователи--------------------------------

  Future<Response> _registration(store) async {
    try {
      var response = await dio
          .get("/install/?store=$store&track=${mainController.deviceID}");
      if (response.data["error"] == true) {
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        await FirebaseAnalytics().logEvent(name: 'COMMON_APP_INSTALL');
        return response;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Response> _launch() async {
    print("launch");
    try {
      var response = await dio.get("/launch/");
      if (response.data["error"] == true) {
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        await FirebaseAnalytics().logEvent(name: 'COMMON_APP_LAUCH');
        return response;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<VideoList> feedId(String id) async {
    print("feedID " + id);
    try {
      var response = await dio.get("/feed/$id");
      if (response.data["error"] == true) {
        await FirebaseAnalytics()
            .logEvent(name: 'API_DEEPLINK_ERROR', parameters: {
          'code': response.data["code"],
          'message': response.data["message"],
        });
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        return videoListFromJson(response.toString());
      }
    } catch (exception) {
      return Future.error(
          "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
    }
  }

  Future<VideoList> feed() async {
    try {
      var response = await dio.get("/feed/");
      if (response.data["error"] == true) {
        await FirebaseAnalytics().logEvent(name: 'API_FEED_ERROR', parameters: {
          'code': response.data["code"],
          'message': response.data["message"],
        });
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        return videoListFromJson(response.toString());
      }
    } catch (exception) {
      return Future.error(
          "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
    }
  }

  Future<Video> next(id) async {
    print("next");
    try {
      var response = await dio.get("/next/$id");
      if (response.data["error"] == true) {
        await FirebaseAnalytics().logEvent(name: 'API_NEXT_ERROR', parameters: {
          'code': response.data["code"],
          'message': response.data["message"],
        });
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        return videoFromJson(response.toString());
      }
    } catch (exception) {
      return Future.error(
          "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
    }
  }

  Future<Video> prev(id) async {
    print("prev");
    try {
      var response = await dio.get("/prev/$id");
      if (response.data["error"] == true) {
        await FirebaseAnalytics().logEvent(name: 'API_PREV_ERROR', parameters: {
          'code': response.data["code"],
          'message': response.data["message"],
        });
        return Future.error(
            "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
      } else {
        return videoFromJson(response.toString());
      }
    } catch (exception) {
      return Future.error(
          "Упс, у нас что-то сломалось. Наши программисты уже чинят.");
    }
  }
}
