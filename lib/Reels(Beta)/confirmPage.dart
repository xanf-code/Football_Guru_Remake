import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ConfirmedPage extends StatefulWidget {
  File videoFile;
  final String videoPath;
  final ImageSource imageSource;
  final User gCurrentUser;

  ConfirmedPage(
      {this.videoFile, this.videoPath, this.imageSource, this.gCurrentUser});
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
    // TODO: implement initState
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

  // createReels(
  //   String name,
  //   String ownerID,
  //   String postId,
  //   String url,
  //   String description,
  //   String songName,
  // ) async {
  //   Map<String, dynamic> data = {
  //     "name": name,
  //     "ownerID": ownerID,
  //     "postId": postId,
  //     "url": url,
  //     "discription": description,
  //     "songName": songName,
  //   };
  //   String jsonBody = json.encode(data);
  //   final headers = {'Content-Type': 'application/json'};
  //   final String apiUrl = "https://reelsapiapp.herokuapp.com/api/postStories";
  //   final encoding = Encoding.getByName('utf-8');
  //
  //   final response = await http.post(
  //     apiUrl,
  //     body: jsonBody,
  //     headers: headers,
  //     encoding: encoding,
  //   );
  //   if (response.statusCode == 200) {
  //     final String responseString = response.body;
  //     print("Almost Done");
  //     return storiesModelFromJson(responseString);
  //   } else {
  //     return null;
  //   }
  // }

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

  compressingVideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videoFile;
    } else {
      final compressedVideo = await FlutterVideoCompress().compressVideo(
        widget.videoPath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: true,
      );
      setState(() {
        widget.videoFile = compressedVideo.file;
      });
    }
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
      Navigator.pop(context);
      setState(() {
        uploading = false;
        postId = Uuid().v4();
        //FlutterVideoCompress().deleteAllCache();
      });
    });
  }

  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingVideo();
    String downloadVideo = await uploadVideo(widget.videoFile);
    //@API POST http://127.0.0.1:5000/api/postStories/
    createReels(
      url: downloadVideo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: SingleChildScrollView(
          child: Column(
            children: [
              uploading ? LinearProgressIndicator() : Text(""),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: VideoPlayer(controller),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  top: 14,
                ),
                child: TextFormField(
                  controller: descTextEditingController,
                  decoration: new InputDecoration(
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
                      return "Caption cannot be more than 30";
                    } else {
                      return null;
                    }
                  },
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controllUploadAndSave(),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8E2DE2),
                        const Color(0xFF4A00E0),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Upload Video",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        AntDesign.rightcircle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
