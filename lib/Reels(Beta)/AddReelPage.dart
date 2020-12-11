import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Reels(Beta)/confirmPage.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as tAgo;

class Reels extends StatefulWidget {
  final String postId;

  const Reels({Key key, this.postId}) : super(key: key);
  @override
  _ReelsState createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  Stream videosStream;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    videosStream = FirebaseFirestore.instance
        .collection("reels")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  final String currentUserOnlineId = currentUser?.id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 65.0),
          child: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            backgroundColor: Color(0xFF7232f2),
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(FontAwesome.file_video_o),
                backgroundColor: Colors.blue,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pickVideo(ImageSource.gallery);
                },
              ),
              // SpeedDialChild(
              //   child: Icon(Ionicons.ios_videocam),
              //   backgroundColor: Colors.green,
              //   onTap: () {
              //     HapticFeedback.mediumImpact();
              //     pickVideo(ImageSource.camera);
              //   },
              // ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF0e0e10),
        body: StreamBuilder(
            stream: videosStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PageView.builder(
                    allowImplicitScrolling: false,
                    itemCount: snapshot.data.docs.length,
                    controller: PageController(
                      initialPage: 0,
                      //viewportFraction: 1,
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DocumentSnapshot videos = snapshot.data.docs[index];
                      bool isPostOwner =
                          currentUserOnlineId == videos.data()["ownerID"];
                      return Stack(
                        children: [
                          VideoPlayerItem(
                            videoUrl: videos.data()["url"],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 14.0,
                                  bottom: 8,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            videos.data()["userPic"],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          videos.data()["name"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      videos.data()["caption"],
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                      endIndent: 20,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.heavyImpact();
                                            likes(
                                              videos.data()["postId"],
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              videos
                                                      .data()["likes"]
                                                      .contains(currentUser.id)
                                                  ? Icon(
                                                      MaterialCommunityIcons
                                                          .fire,
                                                      //size: 15,
                                                      color: Colors.blue,
                                                    )
                                                  : Icon(
                                                      MaterialCommunityIcons
                                                          .fire,
                                                      //size: 15,
                                                      color: Colors.white,
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                videos
                                                    .data()["likes"]
                                                    .length
                                                    .toString(),
                                                style: GoogleFonts.averageSans(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            bottomModal(context,
                                                videos.data()["postId"]);
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.comment,
                                                //size: 15,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                videos
                                                    .data()["commentCount"]
                                                    .toString(),
                                                style: GoogleFonts.averageSans(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isPostOwner
                                            ? GestureDetector(
                                                onTap: () =>
                                                    modalBottomSheetMenu(
                                                  videos.data()["postId"],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Entypo
                                                          .dots_three_horizontal,
                                                      //size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "More",
                                                      style: GoogleFonts
                                                          .averageSans(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () => showAlertDialog(
                                                    context, postID2),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Ionicons.ios_flag,
                                                      //size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "Report",
                                                      style: GoogleFonts
                                                          .averageSans(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              }
            }),
      ),
    );
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
                removeVideo(snapshot);
              },
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: Text("Delete Video"),
              ),
            ),
          ),
        );
      },
    );
  }

  removeVideo(postID) {
    FirebaseFirestore.instance
        .collection("reels")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    }).whenComplete(() {
      Navigator.of(context).pop();
    });

    reelsReference.child("post_$postID.mp4").delete();
  }

  reportComment(String username, String postID) {
    FirebaseFirestore.instance
        .collection("videoReports")
        .doc(postID)
        .collection("reports")
        .add({
      "username": username,
      "postID": postID,
      "postID2": postID2,
    });
  }

  showAlertDialog(BuildContext mContext, var id) {
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
        reportComment(currentUser.username, id);
        Navigator.of(mContext).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF0e0e10),
      content: Text(
        "Are you sure you want to report this video?\nOnce you have reported a video it cannot be undone.",
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

  var _formKey = GlobalKey<FormState>();
  bottomModal(mContext, String postId) {
    showModalBottomSheet(
      context: mContext,
      builder: (BuildContext _) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          color: Color(0xFF0e0e10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
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
                          saveComment(postId);
                        }
                      });
                    },
                    icon: Icon(
                      MaterialCommunityIcons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[800],
                  endIndent: 30,
                  indent: 30,
                ),
                DisplayComments(postId),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  DisplayComments(String id) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("reels")
          .doc(id)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[800],
              endIndent: 30,
              indent: 30,
            ),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot comments = snapshot.data.docs[index];
              return ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                    ),
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${comments.data()["username"]} ",
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: comments.data()["comment"],
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              height: 1.3,
                              letterSpacing: .7,
                              fontSize: 15,
                            ),
                          ),
                        ]),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                comments.data()["url"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          tAgo.format(
                            comments.data()["timestamp"].toDate(),
                          ),
                          style: GoogleFonts.ubuntu(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: FlatButton.icon(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            likeComment(
                              comments.data()["postID"],
                              comments.data()["ref"],
                            );
                          },
                          icon:
                              comments.data()["likes"].contains(currentUser.id)
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

  // like comments
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

  // save comments
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

  var video;
  // video picker
  pickVideo(ImageSource src) async {
    video = await ImagePicker().getVideo(
      source: src,
      maxDuration: Duration(
        seconds: 10,
      ),
    );
    if (video != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ConfirmedPage(
            videoFile: File(video.path),
            imageSource: src,
            videoPath: video.path,
            gCurrentUser: currentUser,
          ),
        ),
      );
    }
  }

  // Add likes
  likes(String id) async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection("reels").doc(id).get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance.collection("reels").doc(id).update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      FirebaseFirestore.instance.collection("reels").doc(id).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key key, this.videoUrl}) : super(key: key);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  CachedVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((_) {
        controller.play();
        controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.value.initialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: InkWell(
                onTap: () {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                },
                child: CachedVideoPlayer(controller),
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}
