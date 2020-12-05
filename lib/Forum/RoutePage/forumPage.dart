import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Forum/CommentsPage/comments.dart';
import 'package:transfer_news/Forum/RoutePage/addPost.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/RealTime/imageDetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ForumDetails extends StatefulWidget {
  final String forumName;
  final List<String> tagName;
  final String appBar;
  const ForumDetails({Key key, this.forumName, this.tagName, this.appBar})
      : super(key: key);
  @override
  _ForumDetailsState createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  int maxMessageToDisplay;
  ScrollController _scrollController;

  void initState() {
    maxMessageToDisplay = 20;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          maxMessageToDisplay += 20;
        });
      }
    });
    super.initState();
  }

  final String currentUserOnlineId = currentUser?.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              AntDesign.aliwangwang_o1,
              size: 24,
            ),
            SizedBox(
              width: 15,
            ),
            Text(widget.appBar),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              MaterialCommunityIcons.fountain_pen,
              size: 30,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xffF58529),
                  Color(0xffFEDA77),
                  Color(0xffDD2A7B),
                  Color(0xff8134AF),
                  Color(0xff515BD4),
                ],
              ),
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => AddPostToForum(
                  name: widget.forumName,
                  tags: widget.tagName.toList(),
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Forum")
            .doc(widget.forumName)
            .collection("Posts")
            .orderBy("timestamp", descending: true)
            .limit(maxMessageToDisplay)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  cacheExtent: 500.0,
                  controller: _scrollController,
                  separatorBuilder: (context, i) {
                    return Divider(
                      color: Colors.grey[800],
                      indent: 10,
                      endIndent: 10,
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot posts = snapshot.data.docs[index];
                    bool isPostOwner =
                        currentUserOnlineId == posts.data()["ownerID"];
                    return Stack(
                      children: [
                        posts.data()["top25"] == true
                            ? Positioned(
                                right: 30,
                                top: 30,
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    Fluttertoast.showToast(
                                      msg: "Top 25 trending",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  },
                                  child: Icon(
                                    Feather.trending_up,
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            right: 12,
                            top: 12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: Image.network(
                                          posts.data()["userPic"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            posts.data()["name"],
                                            style: GoogleFonts.averageSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          posts.data()["isVerified"] != true
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 6.0,
                                                    top: 1,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    height: 15,
                                                    imageUrl:
                                                        "https://webstockreview.net/images/confirmation-clipart-verified.png",
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8,
                                              bottom: 3,
                                            ),
                                            child: Text(
                                              ".",
                                              style: GoogleFonts.rubik(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              tAgo.format(
                                                posts
                                                    .data()["timestamp"]
                                                    .toDate(),
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFF7232f2),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2.0,
                                            bottom: 2,
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Text(
                                            posts
                                                        .data()["tags"]
                                                        .toString()
                                                        .toUpperCase() ==
                                                    ""
                                                ? "Off topic".toUpperCase()
                                                : posts
                                                    .data()["tags"]
                                                    .toString()
                                                    .toUpperCase(),
                                            style: GoogleFonts.openSans(
                                              color: Colors.white70,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        child: Linkify(
                                          onOpen: (link) async {
                                            if (await canLaunch(link.url)) {
                                              await launch(link.url);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Could not launch the link",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          },
                                          text: posts.data()["caption"],
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            height: 1.4,
                                          ),
                                          linkStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      posts.data()["url"] == ""
                                          ? SizedBox(
                                              height: 0,
                                            )
                                          : SizedBox(
                                              height: 12,
                                            ),
                                      posts.data()["url"] == ""
                                          ? const SizedBox.shrink()
                                          : GestureDetector(
                                              onTap: () {
                                                HapticFeedback.mediumImpact();
                                                pushNewScreen(
                                                  context,
                                                  withNavBar: false,
                                                  customPageRoute:
                                                      MorpheusPageRoute(
                                                    builder: (context) =>
                                                        DetailScreen(
                                                      image:
                                                          posts.data()["url"],
                                                      postID: posts
                                                          .data()["postId"],
                                                    ),
                                                    transitionDuration:
                                                        Duration(
                                                      milliseconds: 130,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  height: 250,
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        posts.data()["url"],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton.icon(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      likePost(posts.data()["postId"]);
                                    },
                                    label: Text(
                                      posts.data()["likes"].length.toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    icon: posts
                                            .data()["likes"]
                                            .contains(currentUser.id)
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
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        customPageRoute: MorpheusPageRoute(
                                          builder: (context) =>
                                              CommentsForumPage(
                                            postID: posts.data()["postId"],
                                            path: widget.forumName,
                                          ),
                                          transitionDuration: Duration(
                                            milliseconds: 200,
                                          ),
                                        ),
                                      );
                                    },
                                    label: Text(
                                      "Comment",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    icon: Icon(
                                      MaterialCommunityIcons.comment_outline,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Share.share(
                                        "${posts.data()["caption"]} \nDownload Football Guru App to join the conversation https://play.google.com/store/apps/details?id=com.footballindia.news",
                                      );
                                    },
                                    label: Text(
                                      "Share",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    icon: Icon(
                                      MaterialCommunityIcons.share_outline,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                  isPostOwner
                                      ? FlatButton.icon(
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            modalBottomSheetMenu(
                                              posts.data()["postId"],
                                            );
                                          },
                                          icon: Icon(
                                            Feather.settings,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                          label: Text(
                                            "More",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : FlatButton.icon(
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            reportPost(
                                              posts.data()["postId"],
                                              posts.data()["caption"],
                                            );
                                          },
                                          icon: Icon(
                                            Feather.flag,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          label: Text(
                                            "Report",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  reportPost(postId, post) {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.forumName)
        .collection("Reports")
        .add({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "caption": post,
    }).then((result) {
      Fluttertoast.showToast(
        msg: "Thank you for reporting!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
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
                removePost(snapshot);
              },
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: Text("Delete Post"),
              ),
            ),
          ),
        );
      },
    );
  }

  removePost(postID) async {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.forumName)
        .collection("Posts")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    forumReference.child("post_$postID.jpg").delete();

    FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.forumName)
        .collection("Posts")
        .doc(postID)
        .collection("comments")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  likePost(String id) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.forumName)
        .collection("Posts")
        .doc(id)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(widget.forumName)
          .collection("Posts")
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(widget.forumName)
          .collection("Posts")
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}
