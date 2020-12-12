import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:transfer_news/Forum/Prediction/ISLPredictionPage.dart';
import 'package:transfer_news/Forum/RoutePage/PollPage.dart';
import 'package:transfer_news/Forum/RoutePage/forumPage.dart';
import 'package:transfer_news/Forum/learderboard/showLearderboard.dart';
import 'package:transfer_news/Utils/constants.dart';

class ForumMain extends StatefulWidget {
  final String forumName;
  final List<String> tagName;
  final String appBar;
  final int length;
  const ForumMain(
      {Key key, this.forumName, this.tagName, this.appBar, this.length})
      : super(key: key);
  @override
  _ForumMainState createState() => _ForumMainState();
}

class _ForumMainState extends State<ForumMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.length,
      child: Scaffold(
        backgroundColor: appBG,
        appBar: AppBar(
          backgroundColor: appBG,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(
                AntDesign.aliwangwang_o1,
                size: 24,
              ),
              SizedBox(
                width: 15,
              ),
              Text(widget.appBar),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.length == 4
                    ? TabBar(
                        physics: BouncingScrollPhysics(),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: tagBorder,
                          ),
                        ),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Ionicons.md_football,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Forum",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.poll,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Polls",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.vote_outline,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Predictions",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  EvilIcons.trophy,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Leaderboard",
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: tagBorder,
                          ),
                        ),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Ionicons.md_football,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Forum",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.poll,
                                  color: IconColor,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Tab(
                                  text: "Polls",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        body: widget.length == 4
            ? TabBarView(
                children: [
                  ForumDetails(
                    forumName: widget.forumName,
                    tagName: widget.tagName,
                    appBar: widget.appBar,
                  ),
                  PollPage(
                    route: widget.forumName,
                  ),
                  ISLPrediction(),
                  LearderBoard(),
                ],
              )
            : TabBarView(
                children: [
                  ForumDetails(
                    forumName: widget.forumName,
                    tagName: widget.tagName,
                    appBar: widget.appBar,
                  ),
                  PollPage(
                    route: widget.forumName,
                  ),
                ],
              ),
      ),
    );
  }
}
