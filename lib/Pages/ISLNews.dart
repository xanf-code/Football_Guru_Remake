import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:transfer_news/Animations/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/LiveScore/live.dart';
import 'package:transfer_news/Pages/Stories/updatePage.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/NewsCardWidget.dart';
import 'package:transfer_news/Widgets/storyCard.dart';

class ISLNews extends StatefulWidget {
  final User gCurrentUser;

  const ISLNews({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _ISLNewsState createState() => _ISLNewsState();
}

class _ISLNewsState extends State<ISLNews>
    with AutomaticKeepAliveClientMixin<ISLNews> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List ISLnewsData;

  Future<String> getISLNews() async {
    var response = await http.get(
      "https://iftwc.com/wp-json/wp/v2/posts?categories=101",
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ISLnewsData = jsonResponse;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getISLNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ISLnewsData == null
        ? ShimmerList()
        : SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //BuildStories(),
                buildStories(),
                DelayedDisplay(
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: Duration(milliseconds: 200),
                  child: LiveScoreWidget(
                    leagueId: 223,
                  ),
                ),
                DelayedDisplay(
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: Duration(milliseconds: 300),
                  child: ISLNewsWidget(ISLnewsData: ISLnewsData),
                ),
              ],
            ),
          );
  }

  buildStories() {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 500),
      slidingCurve: Curves.decelerate,
      delay: Duration(milliseconds: 100),
      child: Container(
        height: 100,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("stories")
              .where(
                "timestamp",
                isGreaterThan: DateTime.now().subtract(Duration(hours: 24)),
              )
              .orderBy(
                "timestamp",
                descending: true,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => UploadPage(
                              gCurrentUser: currentUser,
                            ),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: StoryDesign(
                        image: currentUser.url,
                        name: currentUser.username,
                        isUpload: true,
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length == null
                          ? 0
                          : snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data == null) {
                          return SizedBox();
                        } else {
                          return InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => StoryPage(
                                    url: snapshot.data.docs[index]["url"],
                                    caption: snapshot.data.docs[index]
                                        ["caption"],
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                            },
                            child: StoryDesign(
                              image: snapshot.data.docs[index]["url"],
                              name: snapshot.data.docs[index]["name"],
                              isUpload: false,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class StoryPage extends StatelessWidget {
  final storyController = StoryController();
  final String url;
  final String caption;

  StoryPage({Key key, this.url, this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: StoryView(
          controller: storyController,
          storyItems: [
            StoryItem.pageImage(
              duration: Duration(
                seconds: 10,
              ),
              url: url,
              caption: caption,
              controller: storyController,
            ),
          ],
          onComplete: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
