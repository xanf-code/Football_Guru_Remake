import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/Stories/updatePage.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Widgets/StoryPage.dart';
import 'package:transfer_news/Widgets/storyCard.dart';
import 'package:provider/provider.dart';

class Stories extends StatefulWidget {
  const Stories();

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final ScrollController _scrollController = ScrollController();
  int _limit = 7;
  final int _limitIncrement = 10;
  bool _loading = false;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _loading = true;
        _limit += _limitIncrement;
        Future.delayed(
          Duration(
            seconds: 5,
          ),
        ).whenComplete(() {
          setState(() {
            _loading = false;
          });
        });
      });
    }
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 500),
      slidingCurve: Curves.decelerate,
      delay: Duration(milliseconds: 100),
      child: Container(
        height: 90,
        child: StreamBuilder(
          stream: context.watch<Repository>().getStories(_limit),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return SingleChildScrollView(
                controller: _scrollController,
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
                              viewCounter(
                                snapshot.data.docs[index]["postId"],
                              );
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => StoryPage(
                                    url: snapshot.data.docs[index]["url"],
                                    caption: snapshot.data.docs[index]
                                        ["caption"],
                                    userPic: snapshot.data.docs[index]
                                        ["userPic"],
                                    userName: snapshot.data.docs[index]["name"],
                                    viewCount: snapshot
                                        .data.docs[index]["viewed"].length
                                        .toString(),
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
                    _loading == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Center(
                              child: Theme(
                                data: ThemeData(
                                  cupertinoOverrideTheme: CupertinoThemeData(
                                      brightness: Brightness.dark),
                                ),
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  viewCounter(String docID) async {
    await FirebaseFirestore.instance.collection("stories").doc(docID).update({
      'viewed': FieldValue.arrayUnion(
        [currentUser.id],
      )
    });
  }
}
