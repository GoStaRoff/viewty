import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewty/constants/colors.dart';
import 'package:viewty/constants/text_styles.dart';

class UploadDialog extends StatelessWidget {
  const UploadDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            height: Get.height / 2,
            width: Get.width / 1.2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              color: GREY,
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Viewty",
                    style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Идет бета-тестирование и свободная загрузка видео невозможна, но Вы можете связаться с нами, если хотите опубликовать свой контент в нашем приложении",
                    textAlign: TextAlign.center,
                    style: MAIN_TEXT_STYLE_WHITE,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "CONTACT US :",
                    style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String url = "https://www.instagram.com";
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceSafariVC: false,
                          forceWebView: false,
                          headers: <String, String>{
                            'header_key': 'header_value'
                          },
                        );
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        color: Color(0xFF833AB4),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/instagram_icon.png",
                            height: 40,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Написать в Instagram",
                            style: MAIN_TEXT_STYLE_WHITE,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String url = "https://www.tiktok.com";
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceSafariVC: false,
                          forceWebView: false,
                          headers: <String, String>{
                            'header_key': 'header_value'
                          },
                        );
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/tiktok_icon.svg",
                            height: 40,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Написать в TikTok",
                            style: MAIN_TEXT_STYLE_BLACK,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
