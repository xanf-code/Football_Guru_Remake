import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ConfirmedPage extends StatefulWidget {
  File videoFile;
  final String videoPath;
  final ImageSource imageSource;
  final FirebaseUserModel gCurrentUser;
  ConfirmedPage({
    this.videoFile,
    this.videoPath,
    this.imageSource,
    this.gCurrentUser,
  });
  @override
  _ConfirmedPageState createState() => _ConfirmedPageState();
}

class _ConfirmedPageState extends State<ConfirmedPage> {
  String postId = Uuid().v4();
  bool uploading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  VideoPlayerController controller;

  final TextEditingController descTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<String> uploadVideo(mVideoFile) async {
    StorageUploadTask mStorageUploadTask =
        reelsReference.child("post_$postId.mp4").putFile(
              mVideoFile,
              StorageMetadata(contentType: 'video/mp4'),
            );
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  createReels({String url}) {
    FirebaseFirestore.instance.collection("reels").doc(postId).set({
      "postId": postId,
      "ownerID": widget.gCurrentUser.id,
      "timestamp": timeStamp,
      "name": currentUser.username,
      "url": url,
      "likes": [],
      "caption": descTextEditingController.text,
      "userPic": currentUser.url,
      "commentCount": 0,
    }).then((result) {
      setState(() {
        uploading = false;
        postId = Uuid().v4();
      });
      Navigator.pop(context);
    });
  }

  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    String downloadVideo = await uploadVideo(widget.videoFile);
    //@API POST http://127.0.0.1:5000/api/postStories/
    createReels(
      url: downloadVideo,
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VisibilityDetector(
                  key: Key("unique key"),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction == 0) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 60,
                        child: TextFormField(
                          controller: descTextEditingController,
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Octicons.pencil,
                              color: Colors.grey,
                            ),
                            filled: true,
                            labelText: "Enter Caption",
                            hintStyle: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                            labelStyle: GoogleFonts.rubik(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.grey[900],
                            border: InputBorder.none,
                            //fillColor: Colors.green
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Caption cannot be empty";
                            }
                            if (val.length > 30) {
                              return "Caption cannot be more than 30 words";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            controllUploadAndSave();
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFe0f2f1),
                          ),
                          child: Center(
                            child: Icon(
                              Ionicons.ios_send,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            uploading
                ? Stack(
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Loading..",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
