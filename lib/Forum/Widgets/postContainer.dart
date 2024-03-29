import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Forum/CommentsPage/comments.dart';
import 'package:transfer_news/Forum/Widgets/ExpandableText.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/imageDetailScreen.dart';
import 'package:transfer_news/Forum/Logics/forumLogic.dart';
import 'package:transfer_news/Utils/constants.dart';

class PostContainer extends StatelessWidget {
  final DocumentSnapshot post;
  final String route;
  const PostContainer({Key key, @required this.post, @required this.route})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Header(
                  post: post,
                  forumName: route,
                ),
                const SizedBox(
                  height: 12,
                ),
                ExpandableText(
                  post.data()["caption"],
                ),
                post.data()["url"] != ""
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6,
                      ),
              ],
            ),
          ),
          post.data()["url"] != ""
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
                            image: post.data()["url"],
                            postID: post.data()["postId"],
                          ),
                          transitionDuration: Duration(
                            milliseconds: 200,
                          ),
                        ),
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ParallaxImage(
                        extent: 150,
                        image: CachedNetworkImageProvider(
                          post.data()["url"],
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
              posts: post,
              forumName: route,
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final DocumentSnapshot post;
  final String forumName;
  const Header({
    Key key,
    @required this.post,
    this.forumName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
}

class Stats extends StatelessWidget {
  final DocumentSnapshot posts;
  final String forumName;

  Stats({Key key, @required this.posts, @required this.forumName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUserOnlineId = currentUser?.id;
    bool isPostOwner = currentUserOnlineId == posts.data()["ownerID"];
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
                        '${NumberFormat.compact().format(posts.data()["likes"].length)} ',
                        key: ValueKey<String>(
                            '${NumberFormat.compact().format(posts.data()["likes"].length)} '),
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
              Text(
                '${NumberFormat.compact().format(posts.data()["commentCount"])} Comments',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton.icon(
              icon: posts.data()["likes"].contains(currentUser.id)
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
                ForumLogic().likePost(posts.data()["postId"], forumName);
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
                    builder: (context) => CommentsForumPage(
                      postID: posts.data()["postId"],
                      path: forumName,
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
                posts.data()["url"] == ""
                    ? Share.share(
                        "${posts.data()["caption"]} \nDownload Football Guru App to join the conversation https://play.google.com/store/apps/details?id=com.indianfootball.transferNews",
                      )
                    : ForumLogic().imageDownload(
                        posts.data()["url"],
                        posts.data()["caption"],
                        posts.data()["postId"],
                      );
              },
            ),
            isPostOwner || currentUser.isAdmin == true
                ? FlatButton.icon(
                    icon: Unicon(
                      UniconData.uniSetting,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      "More",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      modalBottomSheetMenu(posts.data()["postId"], context);
                    },
                  )
                : FlatButton.icon(
                    icon: Icon(
                      Feather.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      "Report",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      ForumLogic()
                          .reportPost(posts.data()["postId"], forumName);
                    },
                  ),
          ],
        ),
      ],
    );
  }

  modalBottomSheetMenu(snapshot, context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: currentUser.isAdmin == true ? 120 : 60,
          color: Colors.black87,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black87,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    ForumLogic().removePost(snapshot, forumName);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Delete Post",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                currentUser.isAdmin == true
                    ? GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop();
                          posts.data()["top25"] == true
                              ? ForumLogic().removestarPost(snapshot, forumName)
                              : ForumLogic().starPost(snapshot, forumName);
                        },
                        child: ListTile(
                          leading: Icon(
                            posts.data()["top25"] == true
                                ? Icons.star_border_sharp
                                : Icons.star,
                            color: Colors.white,
                          ),
                          title: Text(
                            posts.data()["top25"] == true
                                ? "Remove top 25 (Admin)"
                                : "Make top 25 (Admin)",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
