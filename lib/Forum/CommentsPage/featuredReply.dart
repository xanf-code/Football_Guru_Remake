import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as tAgo;

class FeaturedReplyComments extends StatefulWidget {
  final String postid;
  final String commentID;
  const FeaturedReplyComments({Key key, this.postid, this.commentID})
      : super(key: key);
  @override
  _FeaturedReplyCommentsState createState() => _FeaturedReplyCommentsState();
}

class _FeaturedReplyCommentsState extends State<FeaturedReplyComments> {
  String replyID = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final String currentUserOnlineId = currentUser?.id;
  TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text("Replies"),
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
                      controller: replyController,
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
        .collection("featuredPosts")
        .doc(widget.postid)
        .collection("comments")
        .doc(widget.commentID)
        .collection("replies")
        .doc(replyID)
        .set({
      "username": currentUser.username,
      "comment": replyController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "likes": [],
      "userId": currentUser.id,
      "replyCommentID": replyID,
    });
    setState(() {
      replyController.clear();
      replyID = Uuid().v4();
    });
  }

  displayComment() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("featuredPosts")
          .doc(widget.postid)
          .collection("comments")
          .doc(widget.commentID)
          .collection("replies")
          .orderBy("timestamp", descending: true)
          .limit(75)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          return ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
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
                                  comments.data()["replyCommentID"],
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
                              comments.data()["replyCommentID"],
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

  likeComment(String replyID) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("featuredPosts")
        .doc(widget.postid)
        .collection("comments")
        .doc(widget.commentID)
        .collection("replies")
        .doc(replyID)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
          .collection("featuredPosts")
          .doc(widget.postid)
          .collection("comments")
          .doc(widget.commentID)
          .collection("replies")
          .doc(replyID)
          .update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      FirebaseFirestore.instance
          .collection("featuredPosts")
          .doc(widget.postid)
          .collection("comments")
          .doc(widget.commentID)
          .collection("replies")
          .doc(replyID)
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

  removeComment(replyID) async {
    FirebaseFirestore.instance
        .collection("featuredPosts")
        .doc(widget.postid)
        .collection("comments")
        .doc(widget.commentID)
        .collection("replies")
        .doc(replyID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }
}
