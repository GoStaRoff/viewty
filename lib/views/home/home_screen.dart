import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewty/constants/colors.dart';
import 'package:viewty/views/home/home_controller.dart';
import 'package:viewty/views/player/player_page.dart';

import 'empty_failure_no_internet_view.dart';

class HomeView extends GetView<HomeController> {
  static String id = "/home";

  bool nextUsed = false;
  bool prevUsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GREY,
      ),
      child: Obx(() => controller.connectionStatus.value == 1
          ? controller.obx(
              (state) => Obx(
                () => PageView.builder(
                    onPageChanged: (pageIndex) {
                      if (pageIndex == 1 && !prevUsed) {
                        controller.prevIndex = state!.prev.id;
                        prevUsed = true;
                      } else if (controller.prevPages.length +
                                  controller.nextPages.length +
                                  3 ==
                              pageIndex &&
                          !nextUsed) {
                        controller.nextIndex = state!.next.id;
                        nextUsed = true;
                      }
                    },
                    controller: controller.pageController,
                    itemCount: controller.pages(state).length,
                    itemBuilder: (context, i) {
                      return controller.pages(state)[i];
                    }),
              ),
              onLoading: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              ),
              onError: (error) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: EmptyFailureNoInternetView(
                  image: 'assets/error.png',
                  title: 'Программная ошибка',
                  description: error.toString(),
                  buttonText: "Повторить",
                  onPressed: () {
                    controller.getFeed();
                  },
                ),
              ),
              onEmpty: EmptyFailureNoInternetView(
                image: 'assets/empty.png',
                title: 'Пусто',
                description: 'Вы посмотрели все видео.',
                buttonText: "Повторить",
                onPressed: () {
                  controller.getFeed();
                },
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: EmptyFailureNoInternetView(
                image: 'assets/no_internet.png',
                title: 'Нет интернета',
                description:
                    "Пожалуйста, проверьте подключение и попробуйте еще раз",
                buttonText: "Повторить",
                onPressed: () {
                  controller.getFeed();
                },
              ),
            )),
    );
  }
}
