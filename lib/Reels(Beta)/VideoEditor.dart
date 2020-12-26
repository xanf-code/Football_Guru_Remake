import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Reels(Beta)/confirmPage.dart';
import 'package:video_editor/video_editor.dart';

class VideoEditor extends StatefulWidget {
  VideoEditor({Key key, this.file}) : super(key: key);

  final File file;

  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  VideoEditorController _controller;
  final double height = 60;

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file)
      ..initialize().then((_) => setState(() {}));
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? Stack(
              children: [
                Column(children: [
                  _topNavBar(),
                  Expanded(
                    child: ClipRRect(
                      child: CropGridViewer(
                        controller: _controller,
                        showGrid: false,
                      ),
                    ),
                  ),
                  ..._trimSlider(),
                ]),
                Center(
                  child: OpacityTransition(
                    visible: !_controller.isPlaying,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: Container(
        height: height,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton.icon(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                color: Colors.transparent,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _exportVideo();
                },
                label: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportVideo() async {
    final File file = await _controller.exportVideo(
      videoFormat: "mp4",
      scaleVideo: 0.5,
    );
    if (file != null) {
      await pushNewScreen(
        context,
        withNavBar: false,
        customPageRoute: MorpheusPageRoute(
          builder: (context) => ConfirmedPage(
            videoFile: File(file.path),
            imageSource: ImageSource.gallery,
            videoPath: file.path,
            gCurrentUser: currentUser,
          ),
          transitionDuration: const Duration(
            milliseconds: 200,
          ),
        ),
      ).whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  List<Widget> _trimSlider() {
    final duration = _controller.videoDuration.inSeconds;
    final pos = _controller.trimPosition * duration;
    final start = _controller.minTrim * duration;
    final end = _controller.maxTrim * duration;

    String formatter(Duration duration) =>
        duration.inMinutes.remainder(60).toString().padLeft(2, '0') +
        ":" +
        (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

    return [
      Padding(
        padding: Margin.horizontal(height / 4),
        child: Row(children: [
          TextDesigned(
            formatter(Duration(seconds: pos.toInt())),
            color: Colors.white,
          ),
          Expanded(child: SizedBox()),
          OpacityTransition(
            visible: _controller.isTrimming,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              TextDesigned(
                formatter(Duration(seconds: start.toInt())),
                color: Colors.white,
              ),
              SizedBox(width: 10),
              TextDesigned(
                formatter(Duration(seconds: end.toInt())),
                color: Colors.white,
              ),
            ]),
          )
        ]),
      ),
      Container(
        height: height,
        margin: Margin.all(height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
        ),
      )
    ];
  }
}
