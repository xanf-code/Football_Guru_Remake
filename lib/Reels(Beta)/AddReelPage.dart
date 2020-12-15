import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/VideoPage.dart';
import 'package:transfer_news/Reels(Beta)/confirmPage.dart';
import 'package:transfer_news/Utils/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: FloatingActionButton(
            heroTag: null,
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                MaterialCommunityIcons.video_plus,
                size: 30,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: FABGradient,
              ),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              pickVideo(ImageSource.gallery);
            },
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

                  return VideoPlayer(
                    videos: videos,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  var video;
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
}
