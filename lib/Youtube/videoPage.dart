import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPage extends StatefulWidget {
  final String id;
  final String title;
  final String date;
  final String shareLink;
  final String videoLink;
  final String url;
  const VideoPage(
      {Key key,
      this.id,
      this.title,
      this.date,
      this.shareLink,
      this.videoLink,
      this.url})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController _playerController;

  List alsoWatch = [];
  Future<String> getRecommendations() async {
    var response = await http.get(widget.url);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        alsoWatch = jsonresponse;
      });
    } else {
      print(response.statusCode);
    }
  }

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
    getRecommendations();
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
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Share.share(
                      "${widget.title} "
                      " "
                      "https://www.youtube.com/watch?v=${widget.shareLink}",
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Ionicons.ios_share_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    launch(
                      "https://www.youtube.com/watch?v=${widget.videoLink}",
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Ionicons.ios_globe,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 10.0,
                  ),
                  child: Text(
                    "Watch Next",
                    style: GoogleFonts.averageSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                recVideos(),
              ],
            ),
          );
        },
      ),
    );
  }

  recVideos() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: alsoWatch.length,
      itemBuilder: (context, index) {
        return alsoWatch == null
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                  top: 12,
                  bottom: 12,
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    alsoWatch[index]["snippet"]["title"] == "Private video"
                        ? Fluttertoast.showToast(
                            msg: "Video is made Private",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0,
                          )
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPage(
                                id: alsoWatch[index]["contentDetails"]
                                    ["videoId"],
                                title: alsoWatch[index]["snippet"]["title"],
                                date: alsoWatch[index]["contentDetails"]
                                    ["videoPublishedAt"],
                                shareLink: alsoWatch[index]["contentDetails"]
                                    ["videoId"],
                                videoLink: alsoWatch[index]["contentDetails"]
                                    ["videoId"],
                                url: widget.url,
                              ),
                            ),
                          );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 120,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: alsoWatch[index]["snippet"]["thumbnails"]
                                      ["maxres"] ==
                                  null
                              ? "https://cdn.dribbble.com/users/436757/screenshots/2415904/placeholder_shot_still_2x.gif?compress=1&resize=400x300"
                              : alsoWatch[index]["snippet"]["thumbnails"]
                                  ["maxres"]["url"],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alsoWatch[index]["snippet"]["title"],
                              style: GoogleFonts.averageSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            alsoWatch[index]["snippet"]["title"] ==
                                    "Private video"
                                ? Text(
                                    "Not Available",
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    Jiffy("${alsoWatch[index]["contentDetails"]["videoPublishedAt"]}",
                                            "yyyy-MM-dd")
                                        .fromNow(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
