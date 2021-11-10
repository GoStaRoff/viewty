import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:viewty/model/video_model.dart';
import 'package:viewty/service/api_provider.dart';

class HomeController extends GetxController with StateMixin<VideoList> {
  var video;
  ViewtyApi api = ViewtyApi();

  var connectionStatus = 0.obs;

  //bool isConnected=await InternetConnectionChecker().hasConnection;
  late StreamSubscription<InternetConnectionStatus> _listener;

  @override
  void onInit() {
    _listener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          connectionStatus.value = 1;
          break;
        case InternetConnectionStatus.disconnected:
          connectionStatus.value = 0;
          break;
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getFeed();
  }

  @override
  void onClose() {
    _listener.cancel();
  }

  getFeed() async {
    try {
      change(null, status: RxStatus.loading());
      api.feed().then((value) {
        change(value, status: RxStatus.success());
      }, onError: (err) {
        change(null, status: RxStatus.error(err.toString()));
      });
    } catch (exception) {
      change(null, status: RxStatus.error(exception.toString()));
    }
  }
}
