import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smart_text_view/smart_text_view.dart';
import 'package:transfer_news/Forum/CommentsPage/commentPollPage.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Forum/Logics/logics.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PollContainer extends ChangeNotifier {
  final DocumentSnapshot polls;
  final String route;
  final context;
  PollContainer({this.context, this.route, this.polls});
  Widget pollBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8,
          top: 6,
        ),
        child: Column(
          children: [
            topRow(polls),
            const SizedBox(
              height: 12,
            ),
            middleContainer(polls),
            bottomContainer(polls),
          ],
        ),
      ),
    );
  }

  Widget topRow(post) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl: post.data()["userPic"],
          //hasBorder: true,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.data()["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  post.data()["isVerified"] == true
                      ? CachedNetworkImage(
                          height: 13,
                          imageUrl:
                              "https://webstockreview.net/images/confirmation-clipart-verified.png",
                        )
                      : SizedBox.shrink(),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${tAgo.format(
                      post.data()["timestamp"].toDate(),
                    )} • ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFb92b27),
                    const Color(0xFF1565C0),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    bottom: 4,
                    left: 6,
                    right: 6,
                  ),
                  child: Text(
                    post.data()["tags"].toString().toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            post.data()["top25"] == true
                ? GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Fluttertoast.showToast(
                        msg: "Top 25 trending",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: tagBorder,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Feather.trending_up,
                          size: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Widget middleContainer(posts) {
    double percentage1 =
        polls.data()["option1Votes"] / polls.data()["usersVoted"].length * 100;
    double percentage2 =
        polls.data()["option2Votes"] / polls.data()["usersVoted"].length * 100;
    double percentage3 =
        polls.data()["option3Votes"] / polls.data()["usersVoted"].length * 100;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              PollLogic().checkAndAdd(
                posts.data()["postId"],
                "option1Votes",
                route,
              );
            },
            child: Center(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: LinearPercentIndicator(
                    percent: percentage1 / 100,
                    progressColor: pollColor,
                    animation: true,
                    lineHeight: 50.0,
                    animationDuration: 500,
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${posts.data()["option1"]}",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${percentage1.toStringAsFixed(1)}%",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.white24,
                    linearStrokeCap: LinearStrokeCap.roundAll,
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
              PollLogic()
                  .checkAndAdd(posts.data()["postId"], "option2Votes", route);
            },
            child: Center(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: LinearPercentIndicator(
                    percent: percentage2 / 100,
                    progressColor: pollColor,
                    animation: true,
                    lineHeight: 50.0,
                    animationDuration: 500,
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${posts.data()["option2"]}",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${percentage2.toStringAsFixed(1)}%",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.white24,
                    linearStrokeCap: LinearStrokeCap.roundAll,
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
                    PollLogic().checkAndAdd(
                        posts.data()["postId"], "option3Votes", route);
                  },
                  child: Center(
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: new ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: LinearPercentIndicator(
                          percent: percentage3 / 100,
                          progressColor: pollColor,
                          animation: true,
                          lineHeight: 50.0,
                          animationDuration: 500,
                          center: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${posts.data()["option3"]}",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${percentage3.toStringAsFixed(1)}%",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.white24,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: tagBorder,
                  shape: BoxShape.circle,
                ),
                child: Unicon(
                  UniconData.uniFire,
                  size: 10.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          child: child,
                          scale: animation,
                        );
                      },
                      child: Text(
                        '${NumberFormat.compact().format(polls.data()["usersVoted"].length)} ',
                        key: ValueKey<String>(
                            '${NumberFormat.compact().format(polls.data()["usersVoted"].length)} '),
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'poll votes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomContainer(posts) {
    final String currentUserOnlineId = currentUser?.id;
    bool isPostOwner = currentUserOnlineId == polls.data()["ownerID"];
    return Container(
      height: 50,
      child: Row(
        children: [
          FlatButton.icon(
            label: Text(
              posts.data()["likes"].length == 1
                  ? "${NumberFormat.compact().format(posts.data()["likes"].length)} Vote"
                  : "${NumberFormat.compact().format(posts.data()["likes"].length)} Votes",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: posts.data()["likes"].contains(currentUser.id)
                ? Unicon(
                    UniconData.uniFire,
                    color: Colors.blueAccent,
                    size: 20,
                  )
                : Unicon(
                    UniconData.uniFire,
                    color: Colors.grey,
                    size: 20,
                  ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              PollLogic().likePost(posts.data()["postId"], route);
            },
          ),
          FlatButton.icon(
            label: Text(
              "Comments",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: Unicon(
              UniconData.uniComment,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              pushNewScreen(
                context,
                withNavBar: false,
                customPageRoute: MorpheusPageRoute(
                  builder: (context) => CommentPollPage(
                    postID: posts.data()["postId"],
                    path: route,
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
                    MaterialCommunityIcons.delete_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    PollLogic().removePost(posts.data()["postId"], route);
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
