import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/comments.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:timeago/timeago.dart' as tAgo;

class AllPostWidget extends StatefulWidget {
  final String postId;
  final String ownerId;
  final DateTime timestamp;
  final dynamic likes;
  final String username;
  final String title;
  final String desc;
  final String url;
  final String tag;

  AllPostWidget({
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

  factory AllPostWidget.fromDocument(DocumentSnapshot documentSnapshot) {
    return AllPostWidget(
      username: documentSnapshot["username"],
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerID"],
      likes: documentSnapshot["likes"],
      desc: documentSnapshot["desc"],
      title: documentSnapshot["title"],
      timestamp: documentSnapshot["timestamp"].toDate(),
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
  _AllPostWidgetState createState() => _AllPostWidgetState(
        postId: this.postId,
        ownerId: this.ownerId,
        timestamp: this.timestamp,
        likes: this.likes,
        desc: this.desc,
        title: this.title,
        likeCount: getTotlaNumberOfLikes(this.likes),
        url: this.url,
        username: this.username,
        tag: this.tag,
      );
}

class _AllPostWidgetState extends State<AllPostWidget> {
  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final DateTime timestamp;
  final String tag;
  Map likes;
  final String desc;
  final String title;
  int likeCount;
  bool isLiked;
  bool showfire = false;
  final String currentUserOnlineId = currentUser?.id;

  _AllPostWidgetState(
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
        //Divider(),
        UpvoteButton(),
        // Divider(),
      ],
    );
  }

  removeUserPost() async {
    allPostsReference.doc(postId).get().then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot commentsQuerySnapshot =
        await commentsReference.doc(postId).collection("comments").get();

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

  // addLike() {
  //   bool isnotpostowner = currentUserOnlineId != ownerId;
  //   if (isnotpostowner) {
  //     activityReference.doc(ownerId).collection("feedItems").doc(postId).set({
  //       "activityType": "like",
  //       "username": currentUser.username,
  //       "userId": currentUser.id,
  //       "timestamp": DateTime.now(),
  //       "description": desc,
  //       "title": title,
  //       "postId": postId,
  //       "userProfileImg": currentUser.url
  //     });
  //   }
  // }

  erLikedPost() {
    bool _liked = likes[currentUserOnlineId] == true;

    if (_liked) {
      allPostsReference
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
      allPostsReference
          .doc(postId)
          .update({"likes.$currentUserOnlineId": true});
      // addLike();
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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: GestureDetector(
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
          //removeUserPost();
        },
        child: Card(
          color: Color(0xFF0e0e10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tAgo.format(
                            timestamp,
                          ),
                          style: GoogleFonts.ubuntu(
                            fontSize: 11,
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   parse(desc).documentElement.text,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   style: GoogleFonts.ubuntu(
                        //     fontSize: 12,
                        //     color: Colors.grey[600],
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF7232f2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4,
                              left: 6,
                              right: 6,
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.averageSans(
                                fontSize: 13,
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  UpvoteButton() {
    return Row(
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => erLikedPost(),
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
        ),
      ),
    );
  }
}
