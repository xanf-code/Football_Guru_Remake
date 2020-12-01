import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:uuid/uuid.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;
  final String postUrl;
  final String postTag;
  CommentsPage(
      {this.postId,
      this.postOwnerId,
      this.postDescription,
      this.postType,
      this.postUrl,
      this.postTag});

  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId,
      postOwnerId: postOwnerId,
      postDescription: postDescription,
      postType: postType,
      postUrl: postUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;
  final String postUrl;
  TextEditingController commentTextEditingController = TextEditingController();

  CommentsPageState(
      {Key key,
      this.postId,
      this.postUrl,
      this.postOwnerId,
      this.postDescription,
      this.postType});

  displayComments() {
    return StreamBuilder(
      stream: commentsReference
          .doc(postId)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          physics: BouncingScrollPhysics(),
          children: comments,
        );
      },
    );
  }

  String postID2 = Uuid().v1();
  saveComment() {
    commentsReference.doc(postId).collection("comments").doc(postID2).set({
      "username": currentUser.username,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "userId": currentUser.id,
      "postID": postId,
      "likes": [],
      "postID2": postID2,
    });
    setState(() {
      commentTextEditingController.clear();
      postID2 = Uuid().v1();
    });
  }

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              stretch: true,
              backgroundColor: Color(0xFF0e0e10),
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.postUrl,
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.postType,
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    widget.postTag == " "
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              top: 2,
                              bottom: 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                //width: 50,
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
                                    widget.postTag,
                                    style: GoogleFonts.averageSans(
                                      fontSize: 13,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Divider(
                      color: Colors.grey[700],
                      indent: 10,
                      endIndent: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Html(
                        data: widget.postDescription,
                        defaultTextStyle: GoogleFonts.rubik(
                          color: Colors.grey[400],
                          fontSize: 16,
                          //fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
        floatingActionButton: AvatarGlow(
          endRadius: 40,
          glowColor: Colors.yellow,
          child: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: new BoxDecoration(
                      color: Color(0xFF0e0e10),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This field cannot be empty!";
                                } else {
                                  return null;
                                }
                              },
                              controller: commentTextEditingController,
                              decoration: InputDecoration(
                                labelText: "Add Comment Here",
                                labelStyle:
                                    GoogleFonts.rubik(color: Colors.white),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    saveComment();
                                  }
                                });
                              },
                              child: Container(
                                height: 45,
                                width: 85,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: new LinearGradient(
                                    colors: [
                                      const Color(0xFF3366FF),
                                      const Color(0xFF00CCFF),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Add",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: displayComments(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            backgroundColor: Color(0xFF7232f2),
            child: Icon(
              MaterialCommunityIcons.comment_text_multiple_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userId;
  var likes;
  final String comment;
  final String url;
  final Timestamp timestamp;
  final String postID;
  final String postID2;

  Comment(
      {this.userName,
      this.userId,
      this.comment,
      this.url,
      this.timestamp,
      this.likes,
      this.postID,
      this.postID2});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      userName: documentSnapshot["username"],
      userId: documentSnapshot["userId"],
      comment: documentSnapshot["comment"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
      likes: documentSnapshot["likes"],
      postID: documentSnapshot["postID"],
      postID2: documentSnapshot["postID2"],
    );
  }

  reportComment(String username, String postID) {
    FirebaseFirestore.instance
        .collection("commentReports")
        .doc(postID)
        .collection("reports")
        .add({
      "username": username,
      "userId": userId,
      "postID": postID,
      "postID2": postID2,
      "comment": comment,
    });
  }

  showAlertDialog(BuildContext mContext) {
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.rubik(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        Navigator.of(mContext).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Report",
        style: GoogleFonts.rubik(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        reportComment(userName, postID);
        Navigator.of(mContext).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF0e0e10),
      content: Text(
        "Are you sure you want to report this comment?\nOnce you have reported a comment it cannot be undone.",
        style: GoogleFonts.rubik(
          color: Colors.white,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      useRootNavigator: false,
      context: mContext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    tAgo.format(
                      timestamp.toDate(),
                    ),
                    style: GoogleFonts.openSans(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      url,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  comment,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.flag,
                  color: Colors.white,
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  showAlertDialog(context);
                  // reportComment(userName, postID);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: FlatButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  likeComment(
                    postID,
                    postID2,
                  );
                },
                icon: likes.contains(currentUser.id)
                    ? Icon(
                        Ionicons.ios_heart,
                        color: Colors.red,
                        size: 16,
                      )
                    : Icon(
                        Ionicons.ios_heart,
                        color: Colors.white,
                        size: 16,
                      ),
                label: Text(
                  likes.length.toString() == 0.toString()
                      ? ""
                      : likes.length.toString(),
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  likeComment(String postID, String ref) async {
    DocumentSnapshot docs = await commentsReference
        .doc(postID)
        .collection("comments")
        .doc(ref)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      commentsReference.doc(postID).collection("comments").doc(ref).update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      commentsReference.doc(postID).collection("comments").doc(ref).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}

//commentsReference.doc(postId).collection("comments")
