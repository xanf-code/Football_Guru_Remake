import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentRealTime extends StatefulWidget {
  final String postID;

  const CommentRealTime({Key key, this.postID}) : super(key: key);
  @override
  _CommentRealTimeState createState() => _CommentRealTimeState();
}

class _CommentRealTimeState extends State<CommentRealTime> {
  String commentID = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final String currentUserOnlineId = currentUser?.id;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: displayComment(),
          ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      style: GoogleFonts.openSans(color: Colors.white),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be empty!";
                        } else {
                          return null;
                        }
                      },
                      controller: commentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: InputBorder.none,
                        hintText: "Write here..",
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.grey,
                        ),
                      ),
                      autocorrect: true,
                      //autofocus: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        saveComments();
                      }
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF396afc),
                          const Color(0xFF2948ff),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Feather.send,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveComments() {
    FirebaseFirestore.instance
        .collection("realTimeTweets")
        .doc(widget.postID)
        .collection("comments")
        .doc(commentID)
        .set({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "likes": [],
      "userId": currentUser.id,
      "commentID": commentID,
    });
    setState(() {
      commentController.clear();
      commentID = Uuid().v4();
    });
  }

  displayComment() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("realTimeTweets")
          .doc(widget.postID)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot comments = snapshot.data.docs[index];
              bool isPostOwner =
                  currentUserOnlineId == comments.data()["userId"];
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
                        child: Text(
                          comments.data()["comment"],
                          style: GoogleFonts.montserrat(
                            height: 1.4,
                            color: Colors.white,
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
                                  comments.data()["commentID"],
                                );
                              },
                            )
                          : Text(""),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: FlatButton.icon(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            likeComment(
                              comments.data()["commentID"],
                            );
                          },
                          icon:
                              comments.data()["likes"].contains(currentUser.id)
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  likeComment(String commentID) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("realTimeTweets")
        .doc(widget.postID)
        .collection("comments")
        .doc(commentID)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
          .collection("realTimeTweets")
          .doc(widget.postID)
          .collection("comments")
          .doc(commentID)
          .update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      FirebaseFirestore.instance
          .collection("realTimeTweets")
          .doc(widget.postID)
          .collection("comments")
          .doc(commentID)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
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
        .collection("realTimeTweets")
        .doc(widget.postID)
        .collection("comments")
        .doc(commentID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }
}
