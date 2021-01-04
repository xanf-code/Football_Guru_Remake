import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddNewWallpaper extends StatefulWidget {
  @override
  _AddNewWallpaperState createState() => _AddNewWallpaperState();
}

class _AddNewWallpaperState extends State<AddNewWallpaper> {
  File selectedImage;
  File fileImage;
  String postId = Uuid().v4();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBG,
      ),
      backgroundColor: appBG,
      body: Column(
        children: [
          uploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 500,
            color: Colors.white,
            child: selectedImage != null
                ? Image.file(selectedImage)
                : SizedBox.shrink(),
          ),
          selectedImage != null
              ? FlatButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    controlUploadAndSave();
                  },
                  child: Text("Post Wallpaper"),
                  color: Colors.white,
                )
              : FlatButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    captureImageWithGallery();
                  },
                  child: Text("Add Image"),
                  color: Colors.white,
                ),
        ],
      ),
    );
  }

  //Image from gallery
  Future captureImageWithGallery() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fileImage != null) {
      setState(() {
        selectedImage = fileImage;
      });
    }
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
    if (selectedImage != null) {
      String downloadImage = await uploadImage(selectedImage);
      savePostToDatabase(
        url: downloadImage,
      );
    }
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
      "userPic": currentUser.url,
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        uploading = false;
        postId = Uuid().v4();
        selectedImage = null;
        fileImage = null;
      });
    });
  }
}
