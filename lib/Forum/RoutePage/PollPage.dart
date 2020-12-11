import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  int maxPollsToDisplay;
  ScrollController _scrollController;

  @override
  void initState() {
    maxPollsToDisplay = 20;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          maxPollsToDisplay += 20;
        });
      }
    });
    super.initState();
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
            .limit(maxPollsToDisplay)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return SizedBox();
          } else {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: AnimationLimiter(
                child: ListView.separated(
                  cacheExtent: 500.0,
                  controller: _scrollController,
                  separatorBuilder: (context, i) {
                    return const Divider(
                      color: separatorColor,
                      indent: 10,
                      endIndent: 10,
                    );
                  },
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: Image.network(
                                          posts.data()["userPic"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            posts.data()["name"],
                                            style: GoogleFonts.averageSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          posts.data()["isVerified"] != true
                                              ? const SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 6.0,
                                                    top: 1,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    height: 15,
                                                    imageUrl:
                                                        "https://webstockreview.net/images/confirmation-clipart-verified.png",
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8,
                                              bottom: 3,
                                            ),
                                            child: Text(
                                              ".",
                                              style: GoogleFonts.rubik(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              tAgo.format(
                                                posts
                                                    .data()["timestamp"]
                                                    .toDate(),
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            width: 1,
                                            color: tagBorder,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0,
                                              bottom: 2,
                                              left: 5,
                                              right: 5),
                                          child: Text(
                                            posts
                                                .data()["tags"]
                                                .toString()
                                                .toUpperCase(),
                                            style: GoogleFonts.openSans(
                                              color: Colors.white70,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
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
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                width: 1,
                                                color: tagBorder,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                ),
                                                child: Text(
                                                  posts.data()["option1"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        percent: percentage1 / 100,
                                        progressColor: pollColor,
                                        animation: true,
                                        lineHeight: 20.0,
                                        animationDuration: 1000,
                                        center: Text(
                                          "${percentage1.toStringAsFixed(1)}%",
                                          style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Colors.white24,
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
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
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                width: 1,
                                                color: tagBorder,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                ),
                                                child: Text(
                                                  posts.data()["option2"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        percent: percentage2 / 100,
                                        progressColor: pollColor,
                                        animation: true,
                                        lineHeight: 20.0,
                                        animationDuration: 1000,
                                        center: Text(
                                          "${percentage2.toStringAsFixed(1)}%",
                                          style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Colors.white24,
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                      ),
                                      posts.data()["option3"] == ""
                                          ? const SizedBox.shrink()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                      checkAndAdd(
                                                        posts.data()["postId"],
                                                        "option3Votes",
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.2,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: tagBorder,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 12.0,
                                                          ),
                                                          child: Text(
                                                            posts.data()[
                                                                "option3"],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                LinearPercentIndicator(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.2,
                                                  percent: percentage3 / 100,
                                                  progressColor: pollColor,
                                                  animation: true,
                                                  lineHeight: 20.0,
                                                  animationDuration: 1000,
                                                  center: Text(
                                                    "${percentage3.toStringAsFixed(1)}%",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Colors.white24,
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                ),
                                              ],
                                            ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          FlatButton.icon(
                                            label: Text(
                                              "Comments",
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
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
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    removePost(
                                                      posts.data()["postId"],
                                                    );
                                                  },
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ],
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
