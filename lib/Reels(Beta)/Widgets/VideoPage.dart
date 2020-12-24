import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Reels(Beta)/CommentsPage.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/Logics.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/videoPlayerItems.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayer extends StatelessWidget {
  final DocumentSnapshot videos;
  const VideoPlayer({
    Key key,
    this.videos,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayerItem(
          videoUrl: videos.data()["url"],
          id: videos.data()["postId"],
        ),
        VideoPlayerItems().topHeader(
          videos.data()["userPic"],
          videos.data()["name"],
          videos.data()["timestamp"],
          videos.data()["postId"],
          context,
          videos.data()["ownerID"],
        ),
        VideoPlayerItems().caption(videos.data()["caption"]),
        VideoPlayerItems().footer(
          videos.data()["postId"],
          videos.data()["likes"],
          videos.data()["commentCount"],
          context,
        ),
      ],
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String id;
  const VideoPlayerItem({
    Key key,
    this.videoUrl,
    this.id,
  }) : super(key: key);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  CachedVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then(
        (_) {
          controller.play();
          controller.setLooping(true);
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.value.initialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: GestureDetector(
                onDoubleTap: () {
                  HapticFeedback.mediumImpact();
                  ReelsLogic().likes(widget.id);
                },
                onLongPressStart: (_) {
                  controller.pause();
                },
                onLongPressEnd: (_) {
                  controller.play();
                },
                child: VisibilityDetector(
                  key: Key("unique key"),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction == 0) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  child: CachedVideoPlayer(controller),
                ),
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}
