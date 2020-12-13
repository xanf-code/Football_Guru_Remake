import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' show get;
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smart_text_view/smart_text_view.dart';
import 'package:transfer_news/Forum/CommentsPage/comments.dart';
import 'package:transfer_news/Forum/RoutePage/addPost.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/RealTime/imageDetailScreen.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:transfer_news/Widgets/readMore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as joinPath;

class ForumDetails extends StatefulWidget {
  final String forumName;
  final List<String> tagName;
  final String appBar;
  const ForumDetails({Key key, this.forumName, this.tagName, this.appBar})
      : super(key: key);
  @override
  _ForumDetailsState createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails>
    with AutomaticKeepAliveClientMixin<ForumDetails> {
  final ScrollController _scrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final String currentUserOnlineId = currentUser?.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          heroTag: null,
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
        stream: context.watch<Repository>().getForum(widget.forumName, _limit),
        builder: (context, AsyncSnapshot snapshot) {
          print("building");
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: AnimationLimiter(
                child: ListView.builder(
                  cacheExtent: 500.0,
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot posts = snapshot.data.docs[index];
                    bool isPostOwner =
                        currentUserOnlineId == posts.data()["ownerID"];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: snapshot.data.docs.length,
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: Card(
                            borderOnForeground: true,
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Stack(
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
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    posts.data()["userPic"],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        posts.data()["name"],
                                                        style: GoogleFonts
                                                            .averageSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      posts.data()[
                                                                  "isVerified"] !=
                                                              true
                                                          ? const SizedBox()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 6.0,
                                                                top: 1,
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                height: 15,
                                                                imageUrl:
                                                                    "https://webstockreview.net/images/confirmation-clipart-verified.png",
                                                              ),
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8.0,
                                                          right: 8,
                                                          bottom: 3,
                                                        ),
                                                        child: Text(
                                                          ".",
                                                          style:
                                                              GoogleFonts.rubik(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          tAgo.format(
                                                            posts
                                                                .data()[
                                                                    "timestamp"]
                                                                .toDate(),
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                        width: 1,
                                                        color: tagBorder,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 2.0,
                                                        bottom: 2,
                                                        left: 5,
                                                        right: 5,
                                                      ),
                                                      child: Text(
                                                        posts
                                                                    .data()[
                                                                        "tags"]
                                                                    .toString()
                                                                    .toUpperCase() ==
                                                                ""
                                                            ? "Off topic"
                                                                .toUpperCase()
                                                            : posts
                                                                .data()["tags"]
                                                                .toString()
                                                                .toUpperCase(),
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.white70,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.25,
                                                    child: SmartText(
                                                      text: posts
                                                          .data()["caption"],
                                                      onOpen: (url) {
                                                        launch(url);
                                                      },
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        height: 1.4,
                                                      ),
                                                      linkStyle: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  posts.data()["url"] == ""
                                                      ? const SizedBox(
                                                          height: 0,
                                                        )
                                                      : const SizedBox(
                                                          height: 12,
                                                        ),
                                                  posts.data()["url"] == ""
                                                      ? const SizedBox.shrink()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            pushNewScreen(
                                                              context,
                                                              withNavBar: false,
                                                              customPageRoute:
                                                                  MorpheusPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DetailScreen(
                                                                  image: posts
                                                                          .data()[
                                                                      "url"],
                                                                  postID: posts
                                                                          .data()[
                                                                      "postId"],
                                                                ),
                                                                transitionDuration:
                                                                    Duration(
                                                                  milliseconds:
                                                                      130,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 250,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.25,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                8,
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl: posts
                                                                        .data()[
                                                                    "url"],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FlatButton.icon(
                                                onPressed: () {
                                                  HapticFeedback.mediumImpact();
                                                  likePost(
                                                      posts.data()["postId"]);
                                                },
                                                label: Text(
                                                  "${posts.data()["likes"].length} Votes",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                icon: posts
                                                        .data()["likes"]
                                                        .contains(
                                                            currentUser.id)
                                                    ? Unicon(
                                                        UniconData.uniFire,
                                                        color:
                                                            Colors.blueAccent,
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
                                                    customPageRoute:
                                                        MorpheusPageRoute(
                                                      builder: (context) =>
                                                          CommentsForumPage(
                                                        postID: posts
                                                            .data()["postId"],
                                                        path: widget.forumName,
                                                      ),
                                                      transitionDuration:
                                                          Duration(
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
                                                  MaterialCommunityIcons
                                                      .comment_outline,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  HapticFeedback.mediumImpact();
                                                  posts.data()["url"] == ""
                                                      ? Share.share(
                                                          "${posts.data()["caption"]} \nDownload Football Guru App to join the conversation https://play.google.com/store/apps/details?id=com.indianfootball.transferNews",
                                                        )
                                                      : imageDownload(
                                                          posts.data()["url"],
                                                          posts.data()[
                                                              "caption"],
                                                          posts
                                                              .data()["postId"],
                                                        );
                                                },
                                                label: Text(
                                                  "Share",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                icon: Icon(
                                                  MaterialCommunityIcons
                                                      .share_outline,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                              isPostOwner
                                                  ? FlatButton.icon(
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        modalBottomSheetMenu(
                                                          posts
                                                              .data()["postId"],
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
                                                      splashColor:
                                                          Colors.transparent,
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        reportPost(
                                                          posts
                                                              .data()["postId"],
                                                          posts.data()[
                                                              "caption"],
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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

  var documentDirectory;
  imageDownload(String url, String text, String postID) async {
    var response = await get(url);
    documentDirectory = await getTemporaryDirectory();
    File file = new File(joinPath.join(documentDirectory.path, '$postID.png'));
    file.writeAsBytesSync(response.bodyBytes);
    Share.shareFiles(
      [file.path],
      text: text,
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
          color: Colors.black87,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black87,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
                removePost(snapshot);
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
          ),
        );
      },
    );
  }

  removePost(postID) async {
    // Delete Post Collection
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
    //Delete Post Pic from Storage
    forumReference.child("post_$postID.jpg").delete();

    // Post Individual
    FirebaseFirestore.instance
        .collection("Individual Tweets")
        .doc(currentUser.id)
        .collection("Forum Posts")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
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

  @override
  bool get wantKeepAlive => true;
}
