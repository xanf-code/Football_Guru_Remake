import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/morpheus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/comments.dart';
import 'package:transfer_news/Pages/home.dart';

class FeaturedPostWidget extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String timestamp;
  final dynamic likes;
  final String username;
  final String title;
  final String desc;
  final String url;
  final String tag;
  FeaturedPostWidget({
    this.postId,
    this.ownerId,
    this.timestamp,
    this.likes,
    this.url,
    this.username,
    this.title,
    this.desc,
    this.tag,
  });

  factory FeaturedPostWidget.fromDocument(DocumentSnapshot documentSnapshot) {
    return FeaturedPostWidget(
      username: documentSnapshot["username"],
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerID"],
      likes: documentSnapshot["likes"],
      desc: documentSnapshot["desc"],
      title: documentSnapshot["title"],
      // timestamp: documentSnapshot["timestamp"].toDate(),
      url: documentSnapshot["url"],
      tag: documentSnapshot["tags"],
    );
  }

  int getTotlaNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _FeaturedPostWidgetState createState() => _FeaturedPostWidgetState(
        postId: this.postId,
        ownerId: this.ownerId,
        // timestamp: this.timestamp,
        likes: this.likes,
        desc: this.desc,
        title: this.title,
        likeCount: getTotlaNumberOfLikes(this.likes),
        url: this.url,
        username: this.username,
        tag: this.tag,
      );
}

class _FeaturedPostWidgetState extends State<FeaturedPostWidget> {
  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final DateTime timestamp;
  Map likes;
  final String desc;
  final String title;
  int likeCount;
  bool isLiked;
  bool showfire = false;
  final String currentUserOnlineId = currentUser?.id;
  final String tag;

  _FeaturedPostWidgetState(
      {this.postId,
      this.tag,
      this.username,
      this.url,
      this.ownerId,
      this.likes,
      this.desc,
      this.title,
      this.likeCount,
      this.timestamp});

  final transformationController = TransformationController();
  TextEditingController commentTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserOnlineId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        createPostBody(),
        // Divider(),
        UpvoteButton(),
        // Divider(),
      ],
    );
  }

  removeUserPost() async {
    featuredPostsReference.doc(postId).get().then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot commentsQuerySnapshot = await FirebaseFirestore.instance
        .collection("featuredPosts")
        .doc(postId)
        .collection("comments")
        .get();

    commentsQuerySnapshot.docs.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  removeLike() {
    bool isnotpostowner = currentUserOnlineId != ownerId;

    if (isnotpostowner) {
      activityReference
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  LikedPost() {
    bool _liked = likes[currentUserOnlineId] == true;

    if (_liked) {
      featuredPostsReference
          .doc(postId)
          .update({"likes.$currentUserOnlineId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentUserOnlineId] = false;
        HapticFeedback.mediumImpact();
      });
    } else if (!_liked) {
      featuredPostsReference
          .doc(postId)
          .update({"likes.$currentUserOnlineId": true});
      //addLike();
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentUserOnlineId] = true;
        showfire = true;
        HapticFeedback.mediumImpact();
      });
    }
  }

  createPostBody() {
    return url != null
        ? GestureDetector(
            onTap: () {
              Comments(
                context,
                postId: postId,
                ownerId: ownerId,
                desc: desc,
                title: title,
                postUrl: url,
                tags: tag,
              );
              HapticFeedback.mediumImpact();
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              removeUserPost();
            },
            child: Stack(
              children: [
                Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(url),
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: [
                            Icon(
                              Octicons.comment_discussion,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "$tag",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          title,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        //Colors.black,
                        Colors.transparent,
                        //Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  UpvoteButton() {
    return Row(
      children: [
        Row(
          children: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () => LikedPost(),
              icon: isLiked
                  ? Unicon(
                      UniconData.uniFire,
                      color: Colors.blueAccent,
                    )
                  : Unicon(
                      UniconData.uniFire,
                      color: Colors.white,
                    ),
            ),
            Container(
              child: Text(
                "$likeCount votes",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Comments(BuildContext context,
      {String postId,
      String ownerId,
      String desc,
      String title,
      String postUrl,
      String tags}) {
    pushNewScreen(
      context,
      withNavBar: false,
      customPageRoute: MorpheusPageRoute(
          builder: (context) => CommentsPage(
                postId: postId,
                postOwnerId: ownerId,
                postDescription: desc,
                postType: title,
                postUrl: url,
                postTag: tags,
              ),
          transitionDuration: Duration(
            milliseconds: 200,
          )),
    );
  }
}
