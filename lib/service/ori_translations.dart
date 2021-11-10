import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewty/service/languages/english.dart';

import 'languages/russian.dart';

class OriTranslations extends Translations {
  static Map<String, Locale> languages = {
    // Список языков
    "english": const Locale('en_US'),
    "russian": const Locale('ru_RU'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': english,
        'ru_RU': russian,
      };
}
