import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:viewty/views/home/home_screen.dart';

class DynamicLinksApi {
  static final dynamicLink = FirebaseDynamicLinks.instance;

  static handleDynamicLink() async {
    print("init1");

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        print("succes");
        final Uri? deeplink = dynamicLink?.link;

        if (deeplink != null) {
          print("deeplink data: " + deeplink.queryParameters.values.first);
          Get.offAllNamed(HomeView.id,
              arguments: deeplink.queryParameters.values.first);
        }
      },
      onError: (OnLinkErrorException e) async {
        print(e.message);
      },
    );
  }

  static Future<String> createVideoLink(String videoId, String imageURL) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://viewtyapp.page.link',
      link: Uri.parse('https://www.google.com/video?id=$videoId'),
      androidParameters: AndroidParameters(
        packageName: 'boich.technology.viewty',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Посмотри это видео!',
        description: 'Очень крутой товар',
        imageUrl: Uri.parse(imageURL),
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();

    final Uri dynamicUrl = shortLink.shortUrl;
    print(dynamicUrl);
    return dynamicUrl.toString();
  }
}
