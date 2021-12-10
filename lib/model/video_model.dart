import 'dart:convert';

import 'package:video_player/video_player.dart';

VideoList videoListFromJson(String str) => VideoList.fromJson(json.decode(str));

String videoListToJson(VideoList data) => json.encode(data.toJson());

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class VideoList {
  VideoList({
    required this.prev,
    required this.current,
    required this.next,
  });

  Video prev;
  Video current;
  Video next;

  factory VideoList.fromJson(Map<String, dynamic> json) => VideoList(
        prev: Video.fromJson(json["prev"]),
        current: Video.fromJson(json["current"]),
        next: Video.fromJson(json["next"]),
      );

  Map<String, dynamic> toJson() => {
        "prev": prev.toJson(),
        "current": current.toJson(),
        "next": next.toJson(),
      };
}

class Video {
  Video({
    this.id,
    this.url,
    this.style,
    this.publishedAt,
    this.author,
    this.offer,
  });

  VideoPlayerController? controller;
  int? id;
  String? url;
  String duration = "0";
  String? style;
  DateTime? publishedAt;
  var author;
  var offer;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        url: json["url"],
        style: json["style"],
        publishedAt: DateTime.parse(json["published_at"]),
        author: json["author"],
        offer: json["offer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "style": style,
        "start_date":
            "${publishedAt!.year.toString().padLeft(4, '0')}-${publishedAt!.month.toString().padLeft(2, '0')}-${publishedAt!.day.toString().padLeft(2, '0')}",
        "author": author,
        "offer": offer,
      };

  Future<Null> loadController() async {
    controller = VideoPlayerController.network(url!);
    await controller?.initialize();
    controller?.setLooping(true);
  }
}
