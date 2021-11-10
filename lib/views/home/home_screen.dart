import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewty/constants/colors.dart';
import 'package:viewty/views/home/home_controller.dart';
import 'package:viewty/views/player/player_page.dart';

import 'empty_failure_no_internet_view.dart';

class HomeView extends GetView<HomeController> {
  static String id = "/home";
  final PageController _pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  var prevPages = [].obs;
  var nextPages = [].obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GREY,
        // image: DecorationImage(
        //   scale: 1.5,
        //   repeat: ImageRepeat.repeat,
        //   image: AssetImage("assets/background_image.png"),
        // ),
      ),
      child: Obx(() => controller.connectionStatus.value == 1
          ? controller.obx(
              (state) => Obx(
                () => PageView(
                  // onPageChanged: (int pageIndex) async {
                  //   if (pageIndex == 3 + nextPages.length) {
                  //     controller.api
                  //         .next(state!.next.id)
                  //         .then((value) => nextPages.value = [
                  //               ...nextPages,
                  //               PlayerPage(
                  //                 video: value,
                  //               ),
                  //             ]);
                  //   } else if (pageIndex == 1) {
                  //     controller.api
                  //         .prev(state!.prev.id)
                  //         .then((value) => prevPages.value = [
                  //               ...prevPages,
                  //               PlayerPage(
                  //                 video: value,
                  //               ),
                  //             ]);
                  //     _pageController.animateToPage(2,
                  //         duration: Duration(seconds: 1),
                  //         curve: Curves.fastOutSlowIn);
                  //   }
                  // },
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  children: [
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
                  ],
                ),
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
