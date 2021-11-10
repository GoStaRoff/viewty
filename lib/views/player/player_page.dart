import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:viewty/constants/colors.dart';
import 'package:viewty/constants/text_styles.dart';
import 'package:viewty/main_controller.dart';
import 'package:viewty/model/video_model.dart';
import 'package:viewty/views/home/home_controller.dart';
import 'package:viewty/views/player/upload_dialog.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class PlayerPage extends StatefulWidget {
  final Video video;
  const PlayerPage({Key? key, required this.video}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _controller;
  MainController mainController = Get.find();
  bool sharing = false;

  @override
  void initState() {
    super.initState();
    if (widget.video.url!.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.video.url!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _controller.play();
            _controller.setLooping(true);
          });
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
              child: _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: VideoPlayer(_controller))
                  : const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  sharing = true;
                });
                await WcFlutterShare.share(
                  sharePopupTitle: 'share',
                  subject: 'Product'.tr,
                  text: "Look video about ".tr +
                      '${widget.video.offer["product"]["brand"]["title"]} ${widget.video.offer["product"]["title"]}: [LINK]',
                  fileName: 'map.png',
                  mimeType: 'image/png',
                  bytesOfFile: [],
                );
                setState(() {
                  sharing = false;
                });
              },
              child: CircleAvatar(
                backgroundColor: sharing ? WHITE : WHITE_TRANSPARENT,
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/share.png",
                    gaplessPlayback: false,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: Get.width,
              height: 60.0,
              color: GREY.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.dialog(const UploadDialog());
                      },
                      child: const Icon(
                        Icons.add,
                        color: WHITE,
                        size: 40,
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
                              child: Image.network(
                                  widget.video.offer["product"]["img_preview"]),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.video.offer["product"]["brand"]
                                          ["title"],
                                      style: MAIN_TEXT_STYLE_WHITE,
                                    ),
                                    Text(
                                      widget.video.offer["product"]["title"],
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
                              size: 40,
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
          )
        ],
      ),
    );
  }
}
