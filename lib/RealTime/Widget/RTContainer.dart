import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Forum/Logics/forumLogic.dart';
import 'package:transfer_news/Forum/Widgets/ExpandableText.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/CommentPage.dart';
import 'package:transfer_news/RealTime/Logic/RTLogics.dart';
import 'package:transfer_news/RealTime/imageDetailScreen.dart';
import 'package:transfer_news/Utils/constants.dart';

class RTContainer extends StatelessWidget {
  final String image;
  final String name;
  final Timestamp time;
  final bool isVerified;
  final String tag;
  final String caption;
  final String postImage;
  final String postID;
  final likes;
  const RTContainer({
    Key key,
    this.image,
    this.name,
    this.time,
    this.isVerified,
    this.tag,
    this.caption,
    this.postImage,
    this.postID,
    this.likes,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  imageUrl: image,
                  username: name,
                  timeAgo: time,
                  isVerified: isVerified,
                  tags: tag,
                ),
                const SizedBox(
                  height: 12,
                ),
                ExpandableText(
                  caption,
                ),
                postImage != ""
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6,
                      ),
              ],
            ),
          ),
          postImage != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      pushNewScreen(
                        context,
                        withNavBar: false,
                        customPageRoute: MorpheusPageRoute(
                          builder: (context) => DetailScreen(
                            image: postImage,
                            postID: postID,
                          ),
                          transitionDuration: Duration(
                            milliseconds: 200,
                          ),
                        ),
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: postImage,
                        placeholder: (context, url) => Center(
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
            ),
            child: Stats(
              likes: likes,
              postId: postID,
              postUrl: postImage,
              caption: caption,
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String imageUrl;
  final String username;
  final timeAgo;
  final bool isVerified;
  final String tags;
  const Header(
      {Key key,
      this.imageUrl,
      this.username,
      this.timeAgo,
      this.isVerified,
      this.tags})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl: imageUrl,
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
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  isVerified == true
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
                      timeAgo.toDate(),
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
                    tags.toString().toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Stats extends StatelessWidget {
  final likes;
  final String postId;
  final String postUrl;
  final String caption;

  const Stats({
    Key key,
    this.likes,
    this.postId,
    this.postUrl,
    this.caption,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                        '${NumberFormat.compact().format(likes.length)} ',
                        key: ValueKey<String>(
                            '${NumberFormat.compact().format(likes.length)} '),
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'Votes',
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
        SizedBox(
          height: 5,
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton.icon(
              icon: likes.contains(currentUser.id)
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
              label: Text(
                "Vote",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                RTLogics().likePost(postId);
              },
            ),
            FlatButton.icon(
              icon: Unicon(
                UniconData.uniComment,
                color: Colors.white,
                size: 20.0,
              ),
              label: Text(
                "Comment",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                pushNewScreen(
                  context,
                  withNavBar: false,
                  customPageRoute: MorpheusPageRoute(
                    builder: (context) => CommentRealTime(
                      postID: postId,
                    ),
                    transitionDuration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                );
              },
            ),
            FlatButton.icon(
              icon: Unicon(
                UniconData.uniShare,
                color: Colors.white,
                size: 20.0,
              ),
              label: Text(
                "Share",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                postUrl == ""
                    ? Share.share(
                        "$caption \nDownload Football Guru App to join the conversation https://play.google.com/store/apps/details?id=com.indianfootball.transferNews",
                      )
                    : ForumLogic().imageDownload(
                        postUrl,
                        caption,
                        postId,
                      );
              },
            ),
          ],
        ),
      ],
    );
  }
}
