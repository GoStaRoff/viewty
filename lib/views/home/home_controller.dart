import 'dart:async';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:viewty/model/video_model.dart';
import 'package:viewty/service/api_provider.dart';
import 'package:viewty/service/dynamic_link_api.dart';
import 'package:viewty/views/player/player_page.dart';

class HomeController extends GetxController with StateMixin<VideoList> {
  var video;
  ViewtyApi api = ViewtyApi();

  var connectionStatus = 1.obs;
  var _state;
  //bool isConnected=await InternetConnectionChecker().hasConnection;
  late StreamSubscription<InternetConnectionStatus> _listener;

  late PageController pageController;

  var tempVideo;
  bool closeListener = false;
  var prevIndex;
  var nextIndex;
  var prevPages = [].obs;
  var nextPages = [].obs;
  RxList<dynamic> pages(state) {
    return [
      const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.0,
        ),
      ),
      ...prevPages,
      PlayerPage(
        video: state!.prev,
      ),
      PlayerPage(
        video: state.current,
      ),
      PlayerPage(
        video: state.next,
      ),
      ...nextPages,
      const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.0,
        ),
      ),
    ].obs;
  }

  @override
  void onInit() {
    DynamicLinksApi.handleDynamicLink();
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
    if (Get.arguments != null) {
      getFeedId(Get.arguments[0]);
    } else {
      getFeed();
    }

    pageController = PageController(
      initialPage: 2,
      keepPage: true,
    );

    pageController.addListener(() async {
      final index = pageController.page! > 2
          ? pageController.page!.floor()
          : pageController.page!.ceil();
      // print(pageController.page!);
      if (index == 1 && !closeListener) {
        closeListener = true;
        Video prevVideo = await api.prev(prevIndex);
        _prev(prevVideo);
        prevIndex = prevVideo.id;
        closeListener = false;
        // }
      } else if (prevPages.length + nextPages.length + 3 == index &&
          !closeListener) {
        closeListener = true;
        Video nextVideo = await api.next(nextIndex);
        _next(nextVideo);
        nextIndex = nextVideo.id;
        closeListener = false;
      } else {
        return;
      }
    });
  }

  void _next(video) {
    nextPages.value = [
      ...nextPages.value,
      PlayerPage(
        video: video,
      ),
    ];
    // print(prevPages.length + nextPages.length + 2);
    // pageController.jumpToPage(prevPages.length + nextPages.length + 2);
  }

  void _prev(video) {
    prevPages.value = [
      PlayerPage(
        video: video,
      ),
      ...prevPages.value
    ];
    pageController.jumpToPage(2);
  }

  @override
  void onClose() {
    _listener.cancel();
  }

  getFeedId(String id) async {
    try {
      change(null, status: RxStatus.loading());
      api.feedId(id).then((value) {
        _state = value;
        change(value, status: RxStatus.success());
      }, onError: (err) {
        change(null, status: RxStatus.error(err.toString()));
      });
    } catch (exception) {
      change(null, status: RxStatus.error(exception.toString()));
    }
  }

  getFeed() async {
    try {
      change(null, status: RxStatus.loading());
      api.feed().then((value) {
        _state = value;
        change(value, status: RxStatus.success());
      }, onError: (err) {
        change(null, status: RxStatus.error(err.toString()));
      });
    } catch (exception) {
      change(null, status: RxStatus.error(exception.toString()));
    }
  }
}
