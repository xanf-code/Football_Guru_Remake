import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Youtube/videoPage.dart';

class ContentList extends StatefulWidget {
  final String title;
  final String urlPath;
  const ContentList({Key key, this.title, this.urlPath}) : super(key: key);
  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  List videoList;
  Future<String> getNTVideos() async {
    var response = await http.get(widget.urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        videoList = jsonresponse;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getNTVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 220,
            child: videoList == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    itemCount: videoList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MorpheusPageRoute(
                              builder: (context) => VideoPage(
                                id: videoList[index]["contentDetails"]
                                    ["videoId"],
                                title: videoList[index]["snippet"]["title"],
                                date: videoList[index]["contentDetails"]
                                    ["videoPublishedAt"],
                                desc: videoList[index]["snippet"]
                                    ["description"],
                              ),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          height: 200,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                videoList[index]["snippet"]["thumbnails"]
                                            ["maxres"] ==
                                        null
                                    ? "https://cdn.dribbble.com/users/436757/screenshots/2415904/placeholder_shot_still_2x.gif?compress=1&resize=400x300"
                                    : videoList[index]["snippet"]["thumbnails"]
                                        ["maxres"]["url"],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
