import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:viewty/constants/text_styles.dart';

class EmptyFailureNoInternetView extends StatelessWidget {
  EmptyFailureNoInternetView(
      {required this.image,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.onPressed});

  final String title, description, buttonText, image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: Get.height / 6,
          ),
          Image.asset(
            image,
            color: Colors.white,
            height: 250,
            width: 250,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            title,
            style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 22),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style: MAIN_TEXT_STYLE_WHITE,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                child: Text(
                  buttonText,
                  style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 24),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
