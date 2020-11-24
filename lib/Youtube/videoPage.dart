import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  final String id;
  final String title;
  final String date;
  final String desc;
  const VideoPage({Key key, this.id, this.title, this.date, this.desc})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController _playerController;

  void runYoutubePlayer() {
    _playerController = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        enableCaption: false,
        isLive: false,
        autoPlay: false,
      ),
    );
  }

  @override
  void initState() {
    runYoutubePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    _playerController.reset();
    _playerController.pause();
    super.dispose();
  }

  bool showAppBar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Color(0xFF0e0e10),
            )
          : null,
      body: YoutubePlayerBuilder(
        onEnterFullScreen: () {
          setState(() {
            showAppBar = false;
          });
        },
        onExitFullScreen: () {
          setState(() {
            showAppBar = true;
          });
        },
        player: YoutubePlayer(
          controller: _playerController,
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8,
                  ),
                  child: Text(
                    Jiffy("${widget.date}", "yyyy-MM-dd").fromNow(),
                    style: GoogleFonts.rubik(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Html(
                    data: widget.desc,
                    defaultTextStyle: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    onLinkTap: (url) {
                      launch(url);
                    },
                    linkStyle: GoogleFonts.averageSans(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
