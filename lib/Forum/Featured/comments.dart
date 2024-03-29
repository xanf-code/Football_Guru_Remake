import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/CommentsPage/featuredReply.dart';
import 'package:transfer_news/Forum/CommentsPage/replyToComments.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as tAgo;

class FeaturedComments extends StatefulWidget {
  final String postId;

  const FeaturedComments({Key key, this.postId}) : super(key: key);
  @override
  _FeaturedCommentsState createState() => _FeaturedCommentsState();
}

class _FeaturedCommentsState extends State<FeaturedComments> {
  TextEditingController commentTextEditingController = TextEditingController();
  String commentID = Uuid().v1();
  final _formKey = GlobalKey<FormState>();
  final String currentUserOnlineId = currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text("Comments"),
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
                      controller: commentTextEditingController,
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
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        saveComment();
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

  displayComment() {
    return StreamBuilder(
      stream: featuredPostsReference
          .doc(widget.postId)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .limit(75)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
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
                          const SizedBox(
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
                            pushNewScreen(
                              context,
                              withNavBar: false,
                              customPageRoute: MorpheusPageRoute(
                                builder: (context) => FeaturedReplyComments(
                                  postid: widget.postId,
                                  commentID: comments.data()["commentID"],
                                ),
                                transitionDuration: Duration(
                                  milliseconds: 200,
                                ),
                              ),
                            );
                          },
                          icon: Unicon(
                            UniconData.uniCommentAlt,
                            color: Colors.grey,
                            size: 20,
                          ),
                          label: Text(
                            comments.data()["replyCount"].toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          likeComment(
                            comments.data()["commentID"],
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
                  const SizedBox(
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

  saveComment() {
    featuredPostsReference
        .doc(widget.postId)
        .collection("comments")
        .doc(commentID)
        .set({
      "username": currentUser.username,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "userId": currentUser.id,
      "postID": widget.postId,
      "likes": [],
      "commentID": commentID,
      "replyCount": 0,
    });
    setState(() {
      commentTextEditingController.clear();
      commentID = Uuid().v1();
    });
  }

  likeComment(String commentID) async {
    DocumentSnapshot docs = await featuredPostsReference
        .doc(widget.postId)
        .collection("comments")
        .doc(commentID)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      featuredPostsReference
          .doc(widget.postId)
          .collection("comments")
          .doc(commentID)
          .update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      featuredPostsReference
          .doc(widget.postId)
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
    featuredPostsReference
        .doc(widget.postId)
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
