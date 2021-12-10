import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:viewty/constants/colors.dart';
import 'package:viewty/constants/text_styles.dart';
import 'package:viewty/main_controller.dart';
import 'package:viewty/model/video_model.dart';
import 'package:viewty/service/dynamic_link_api.dart';
import 'package:viewty/views/home/home_controller.dart';
import 'package:viewty/views/player/upload_dialog.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class PlayerPage extends StatefulWidget {
  final Video video;
  final onInit;
  const PlayerPage({Key? key, required this.video, this.onInit})
      : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  MainController mainController = Get.find();
  HomeController homeController = Get.find();
  bool sharing = false;
  double videoDurationValue = 0.0;

  useAnalytics(String eventName) {
    print(widget.video.id);
    FirebaseAnalytics().logEvent(name: eventName, parameters: {
      'video_id': widget.video.id,
      'duration': widget.video.duration,
      'style': widget.video.style,
      'author': widget.video.author["nickname"],
      'brand': widget.video.offer["product"]["brand"]["title"],
      'offer': widget.video.offer["product"]["title"],
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.video.id.toString() + " started!!!");
    homeController.currentVideo = widget.video;

    if (widget.video.controller == null) {
      widget.video.loadController().then(
        (_) {
          widget.video.controller!.addListener(() {
            setState(() {});
            try {
              homeController.currentVideo.duration =
                  (widget.video.controller!.value.position.inSeconds /
                          widget.video.controller!.value.duration.inSeconds *
                          100)
                      .floor()
                      .toString();
            } catch (e) {}
            // print(widget.video.controller!.value.position.inSeconds == );
            if (widget.video.controller!.value.position.inSeconds ==
                widget.video.controller!.value.duration.inSeconds) {
              useAnalytics("FEED_VIDEO_VIEW");
            }
          });
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            widget.video.controller!.play();
            widget.video.controller!.setLooping(true);
          });
        },
      );
    } else {
      widget.video.controller!.play();
    }

    if (widget.onInit != null) {
      Future.delayed(Duration.zero, () async {
        widget.onInit();
      });
    }
  }

  @override
  void dispose() {
    print(widget.video.id.toString() + " disposed!!!");
    // widget.video.controller!.dispose();
    widget.video.controller!.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: Center(
              child: widget.video.controller!.value.isInitialized
                  ? GestureDetector(
                      onTap: () async {
                        setState(() {
                          widget.video.controller!.value.isPlaying
                              ? widget.video.controller!.pause()
                              : widget.video.controller!.play();
                        });
                      },
                      child: VideoPlayer(widget.video.controller!))
                  : const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
            ),
          ),
          !widget.video.controller!.value.isPlaying &&
                  widget.video.controller!.value.isInitialized
              ? Positioned(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        widget.video.controller!.play();
                      });
                    },
                    child: const Icon(
                      Icons.pause,
                      color: WHITE,
                      size: 60,
                    ),
                  ),
                )
              : Container(),
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  sharing = true;
                });
                useAnalytics("FEED_SHARE_CLICK");
                String dynamicLink = await DynamicLinksApi.createVideoLink(
                    widget.video.id.toString(),
                    widget.video.offer["product"]["img_preview"]);
                await WcFlutterShare.share(
                  sharePopupTitle: 'share',
                  subject: 'Product'.tr,
                  text: "Look video about ".tr +
                      '${widget.video.offer["product"]["brand"]["title"]} ${widget.video.offer["product"]["title"]}: $dynamicLink',
                  mimeType: 'text/plain',
                );
                useAnalytics("FEED_SHARE_DONE");
                setState(() {
                  sharing = false;
                });
              },
              child: CircleAvatar(
                backgroundColor: sharing ? WHITE : WHITE_TRANSPARENT,
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/share_icon.svg",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: Get.width,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: GREY.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            useAnalytics("FEED_PLUS_CLICK");
                            Get.dialog(UploadDialog(
                              useAnalytics: useAnalytics,
                            ));
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: WHITE,
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              String url = widget.video.offer["url"];
                              if (await canLaunch(url)) {
                                useAnalytics("FEED_OFFER_CLICK");
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
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  color: WHITE,
                                  child: Image.network(widget
                                      .video.offer["product"]["img_preview"]),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.video.offer["product"]["brand"]
                                              ["title"],
                                          style: MAIN_TEXT_STYLE_WHITE,
                                        ),
                                        Text(
                                          widget.video.offer["product"]
                                              ["title"],
                                          overflow: TextOverflow.ellipsis,
                                          style: MAIN_TEXT_STYLE_WHITE.copyWith(
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 30,
                                  color: WHITE,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.video.controller!.value.isInitialized
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.black,
                        color: WHITE,
                        value: widget
                                .video.controller!.value.position.inSeconds /
                            widget.video.controller!.value.duration.inSeconds,
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
