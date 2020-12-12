import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smart_text_view/smart_text_view.dart';
import 'package:transfer_news/Forum/CommentsPage/commentPollPage.dart';
import 'package:transfer_news/Forum/RoutePage/addPoll.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PollPage extends StatefulWidget {
  final String route;

  const PollPage({Key key, this.route}) : super(key: key);
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage>
    with AutomaticKeepAliveClientMixin<PollPage> {
  @override
  bool get wantKeepAlive => true;

  final String currentUserOnlineId = currentUser?.id;
  final ScrollController _scrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;
  Stream predictionStream;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
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
    return Scaffold(
      backgroundColor: appBG,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          heroTag: null,
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              MaterialCommunityIcons.poll,
              size: 30,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xffF58529),
                  Color(0xffFEDA77),
                  Color(0xffDD2A7B),
                  Color(0xff8134AF),
                  Color(0xff515BD4),
                ],
              ),
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => AddPollPage(
                  route: widget.route,
                  tags: pollTags,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Forum")
            .doc(widget.route)
            .collection("Polls")
            .orderBy("timestamp", descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://ouch-cdn.icons8.com/preview/606/90c1f2d7-b42f-4d7e-9d17-e183179862b7.png",
                    width: 400,
                  ),
                ),
                Text(
                  "Post something :<",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          } else {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: AnimationLimiter(
                child: ListView.builder(
                  cacheExtent: 500.0,
                  controller: _scrollController,
                  // separatorBuilder: (context, i) {
                  //   return const Divider(
                  //     color: separatorColor,
                  //     indent: 10,
                  //     endIndent: 10,
                  //   );
                  // },
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot posts = snapshot.data.docs[index];
                    bool isPostOwner =
                        currentUserOnlineId == posts.data()["ownerID"];
                    double percentage1 = posts.data()["option1Votes"] /
                        posts.data()["usersVoted"].length *
                        100;
                    double percentage2 = posts.data()["option2Votes"] /
                        posts.data()["usersVoted"].length *
                        100;
                    double percentage3 = posts.data()["option3Votes"] /
                        posts.data()["usersVoted"].length *
                        100;
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: snapshot.data.docs.length,
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: Card(
                            color: Colors.black87,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10,
                                top: 3,
                                bottom: 3,
                              ),
                              child: Column(
                                children: [
                                  //Header
                                  Container(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                posts.data()["userPic"],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      posts.data()["name"],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    currentUser.isVerified ==
                                                            true
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 3.0,
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              height: 15,
                                                              imageUrl:
                                                                  "https://webstockreview.net/images/confirmation-clipart-verified.png",
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    gradient:
                                                        new LinearGradient(
                                                      colors: [
                                                        const Color(0xFFb92b27),
                                                        const Color(0xFF1565C0),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4.0,
                                                        bottom: 4,
                                                        left: 6,
                                                        right: 6,
                                                      ),
                                                      child: Text(
                                                        posts
                                                            .data()["tags"]
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          tAgo.format(
                                            posts.data()["timestamp"].toDate(),
                                          ),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  //Content
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SmartText(
                                          text: posts.data()["question"],
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            height: 1.4,
                                            fontSize: 18,
                                          ),
                                          linkStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                          onOpen: (url) {
                                            launch(url);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            checkAndAdd(
                                              posts.data()["postId"],
                                              "option1Votes",
                                            );
                                          },
                                          child: Center(
                                            child: ClipRRect(
                                              child: BackdropFilter(
                                                filter: new ImageFilter.blur(
                                                    sigmaX: 10.0, sigmaY: 10.0),
                                                child: LinearPercentIndicator(
                                                  percent: percentage1 / 100,
                                                  progressColor: pollColor,
                                                  animation: true,
                                                  lineHeight: 50.0,
                                                  animationDuration: 500,
                                                  center: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${posts.data()["option1"]}",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${percentage1.toStringAsFixed(1)}%",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.white24,
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            checkAndAdd(
                                              posts.data()["postId"],
                                              "option2Votes",
                                            );
                                          },
                                          child: Center(
                                            child: ClipRRect(
                                              child: BackdropFilter(
                                                filter: new ImageFilter.blur(
                                                    sigmaX: 10.0, sigmaY: 10.0),
                                                child: LinearPercentIndicator(
                                                  percent: percentage2 / 100,
                                                  progressColor: pollColor,
                                                  animation: true,
                                                  lineHeight: 50.0,
                                                  animationDuration: 500,
                                                  center: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${posts.data()["option2"]}",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${percentage2.toStringAsFixed(1)}%",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.white24,
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      posts.data()["option3"] == ""
                                          ? const SizedBox.shrink()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.mediumImpact();
                                                  checkAndAdd(
                                                    posts.data()["postId"],
                                                    "option3Votes",
                                                  );
                                                },
                                                child: Center(
                                                  child: ClipRRect(
                                                    child: BackdropFilter(
                                                      filter:
                                                          new ImageFilter.blur(
                                                        sigmaX: 10.0,
                                                        sigmaY: 10.0,
                                                      ),
                                                      child:
                                                          LinearPercentIndicator(
                                                        percent:
                                                            percentage3 / 100,
                                                        progressColor:
                                                            pollColor,
                                                        animation: true,
                                                        lineHeight: 50.0,
                                                        animationDuration: 500,
                                                        center: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${posts.data()["option3"]}",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${percentage3.toStringAsFixed(1)}%",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        backgroundColor:
                                                            Colors.white24,
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          "${posts.data()["usersVoted"].length} poll votes",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  //Footer
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        FlatButton.icon(
                                          label: Text(
                                            posts.data()["likes"].length == 1
                                                ? "${posts.data()["likes"].length} Vote"
                                                : "${posts.data()["likes"].length} Votes",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          icon: posts
                                                  .data()["likes"]
                                                  .contains(currentUser.id)
                                              ? Unicon(
                                                  UniconData.uniFire,
                                                  color: Colors.blueAccent,
                                                  size: 19,
                                                )
                                              : Unicon(
                                                  UniconData.uniFire,
                                                  color: Colors.grey,
                                                  size: 19,
                                                ),
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            likePost(
                                              posts.data()["postId"],
                                            );
                                          },
                                        ),
                                        FlatButton.icon(
                                          label: Text(
                                            "Comments",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          icon: Icon(
                                            MaterialCommunityIcons
                                                .comment_outline,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            pushNewScreen(
                                              context,
                                              withNavBar: false,
                                              customPageRoute:
                                                  MorpheusPageRoute(
                                                builder: (context) =>
                                                    CommentPollPage(
                                                  postID:
                                                      posts.data()["postId"],
                                                  path: widget.route,
                                                ),
                                                transitionDuration: Duration(
                                                  milliseconds: 200,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        isPostOwner
                                            ? FlatButton.icon(
                                                label: Text(
                                                  "Remove",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                icon: Icon(
                                                  MaterialCommunityIcons
                                                      .delete_circle_outline,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.mediumImpact();
                                                  removePost(
                                                    posts.data()["postId"],
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  removePost(String postID) {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.route)
        .collection("Polls")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  likePost(String id) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.route)
        .collection("Polls")
        .doc(id)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
        ..collection("Forum")
            .doc(widget.route)
            .collection("Polls")
            .doc(id)
            .update({
          'likes': FieldValue.arrayRemove(
            [currentUser.id],
          )
        });
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(widget.route)
          .collection("Polls")
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }

  checkAndAdd(postID, String optionID) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.route)
        .collection("Polls")
        .doc(postID)
        .get();
    if (docs.data()['usersVoted'].contains(currentUser.id)) {
      Fluttertoast.showToast(
        msg: "You have already voted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(widget.route)
          .collection("Polls")
          .doc(postID)
          .update({
        'usersVoted': FieldValue.arrayUnion(
          [currentUser.id],
        )
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection("Forum")
            .doc(widget.route)
            .collection("Polls")
            .doc(postID)
            .update(
          {
            optionID: FieldValue.increment(1),
          },
        );
      });
    }
  }
}
