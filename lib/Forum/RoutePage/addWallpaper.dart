import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddNewWallpaper extends StatefulWidget {
  final File image;

  const AddNewWallpaper({Key key, this.image}) : super(key: key);
  @override
  _AddNewWallpaperState createState() => _AddNewWallpaperState();
}

class _AddNewWallpaperState extends State<AddNewWallpaper> {
  String postId = Uuid().v4();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.file(widget.image),
            ),
          ),
          uploading
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      controlUploadAndSave();
                    },
                    child: Container(
                      height: 50,
                      //width: 130,
                      decoration: BoxDecoration(
                        gradient: createRoomGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Post Wallpaper",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          uploading
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<String> uploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask = FirebaseStorage.instance
        .ref()
        .child("Wallpapers")
        .child("post_$postId.jpg")
        .putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload and save
  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    String downloadImage = await uploadImage(widget.image);
    savePostToDatabase(
      url: downloadImage,
    );
  }

  //save to database with url
  savePostToDatabase({String url}) {
    FirebaseFirestore.instance.collection("wallpaper").doc(postId).set({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "url": url,
      "likes": [],
      "downloadCount": 0,
      "userPic": currentUser.url,
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        uploading = false;
        postId = Uuid().v4();
      });
    });
  }
}
