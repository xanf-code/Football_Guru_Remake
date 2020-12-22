import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realtime_pagination/realtime_pagination.dart';
import 'package:smart_text_view/smart_text_view.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ReelsCommentsPage extends StatefulWidget {
  final String postId;

  const ReelsCommentsPage({Key key, this.postId}) : super(key: key);
  @override
  _ReelsCommentsPageState createState() => _ReelsCommentsPageState();
}

class _ReelsCommentsPageState extends State<ReelsCommentsPage> {
  TextEditingController commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final String currentUserOnlineId = currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: DisplayComments(widget.postId),
          ),
          Form(
            key: _formKey,
            child: ListTile(
              title: TextFormField(
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
                controller: commentController,
                decoration: InputDecoration(
                  labelText: "Add Comment Here",
                  labelStyle: GoogleFonts.rubik(color: Colors.white),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      saveComment(widget.postId);
                    }
                  });
                },
                icon: Icon(
                  MaterialCommunityIcons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  likeComment(String postID, String ref) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("reels")
        .doc(postID)
        .collection("comments")
        .doc(ref)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
          .collection("reels")
          .doc(postID)
          .collection("comments")
          .doc(ref)
          .update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      FirebaseFirestore.instance
          .collection("reels")
          .doc(postID)
          .collection("comments")
          .doc(ref)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }

  DisplayComments(String id) {
    return RealtimePagination(
        query: FirebaseFirestore.instance
            .collection("reels")
            .doc(id)
            .collection("comments")
            .orderBy("timestamp", descending: true),
        itemsPerPage: 10,
        itemBuilder: (index, context, snapshot) {
          DocumentSnapshot comments = snapshot;
          bool isPostOwner = currentUserOnlineId == comments.data()["userId"];
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        comments.data()["username"],
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        tAgo.format(
                          comments.data()["timestamp"].toDate(),
                        ),
                        style: GoogleFonts.openSans(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              comments.data()["url"],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SmartText(
                      text: comments.data()["comment"],
                      onOpen: (link) {
                        launch(link);
                      },
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      linkStyle: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  trailing: isPostOwner
                      ? IconButton(
                          splashRadius: 1,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Entypo.dots_three_vertical,
                            color: Colors.grey,
                            size: 14,
                          ),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            modalBottomSheetMenu(
                              comments.data()["ref"],
                            );
                          },
                        )
                      : Text(""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Row(
                  children: [
                    FlatButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        likeComment(
                          comments.data()["commentID"],
                          comments.data()["ref"],
                        );
                      },
                      icon: comments.data()["likes"].contains(currentUser.id)
                          ? Icon(
                              AntDesign.heart,
                              color: Colors.red,
                              size: 20,
                            )
                          : Icon(
                              Feather.heart,
                              color: Colors.grey,
                              size: 20,
                            ),
                      label: Text(
                        comments.data()["likes"].length.toString() ==
                                0.toString()
                            ? ""
                            : comments.data()["likes"].length.toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  String postID2 = Uuid().v1();
  saveComment(String id) {
    FirebaseFirestore.instance
        .collection("reels")
        .doc(id)
        .collection("comments")
        .doc(postID2)
        .set({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "userId": currentUser.id,
      "postID": id,
      "likes": [],
      "ref": postID2,
    }).whenComplete(() {
      FirebaseFirestore.instance.collection("reels").doc(id).update(
        {
          "commentCount": FieldValue.increment(1),
        },
      );
    });
    setState(() {
      commentController.clear();
      postID2 = Uuid().v1();
    });
  }

  modalBottomSheetMenu(snapshot) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 60,
          color: Colors.transparent,
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
                removeComment(snapshot);
              },
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: Text("Delete Comment"),
              ),
            ),
          ),
        );
      },
    );
  }

  removeComment(commentID) async {
    FirebaseFirestore.instance
        .collection("reels")
        .doc(widget.postId)
        .collection("comments")
        .doc(commentID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    }).whenComplete(() {
      FirebaseFirestore.instance.collection("reels").doc(widget.postId).update(
        {
          "commentCount": FieldValue.increment(-1),
        },
      );
    });
  }
}
