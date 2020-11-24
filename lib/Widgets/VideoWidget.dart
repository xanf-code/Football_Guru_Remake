import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/transferapp-18e5d.appspot.com/o/assetvideos%2Fvideoplayback_3jf5DH1e_off8.mp4?alt=media&token=08d0fbec-9732-4b53-8025-7141a4360b19")
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.initialized
          ? LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              },
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
