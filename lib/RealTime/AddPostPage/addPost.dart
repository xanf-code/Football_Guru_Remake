import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddRealTime extends StatefulWidget {
  @override
  _AddRealTimeState createState() => _AddRealTimeState();
}

class _AddRealTimeState extends State<AddRealTime> {
  File selectedImage;
  File fileImage;
  //File croppedImage;
  String postId = Uuid().v4();
  bool uploading = false;
  TextEditingController descController = TextEditingController();
  TextEditingController correspondentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            setState(() {
              selectedImage = null;
            });
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (_formKey.currentState.validate()) {
                  controlUploadAndSave();
                }
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xff8134AF),
                      Color(0xff515BD4),
                    ],
                  ),
                ),
                child: Center(
                  child: Text("Post"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uploading ? LinearProgressIndicator() : Text(""),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: descController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 300,
                        maxLengthEnforced: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Description cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          counterStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: "Add your post here...",
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 40.0),
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 17),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 17),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 99999,
                        autofocus: false,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: correspondentController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 35,
                        maxLengthEnforced: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          counterStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: "Eg: Correspondent at IFTWC",
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 40.0),
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 17),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 17),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: GoogleFonts.averageSans(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        autofocus: false,
                      ),
                    ),
                  ],
                ),
              ),
              selectedImage == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFF7232f2),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          modalBottomSheetMenu();
                        },
                      ),
                    )
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.black,
                            child: Image.file(selectedImage),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 20,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              setState(
                                () {
                                  selectedImage = null;
                                },
                              );
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Modal
  modalBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 120,
          color: Colors.transparent,
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    captureImageWithGallery();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: Colors.grey,
                    ),
                    title: Text("Pick from gallery"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    captureImageWithCamera();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    title: Text("Open Camera"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Image from gallery
  Future captureImageWithGallery() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fileImage != null) {
      // croppedImage = await ImageCropper.cropImage(
      //   sourcePath: fileImage.path,
      //   aspectRatio: CropAspectRatio(
      //     ratioX: 1,
      //     ratioY: 1,
      //   ),
      //   maxWidth: 700,
      //   maxHeight: 700,
      //   androidUiSettings: AndroidUiSettings(
      //     toolbarTitle: "Crop Image",
      //     toolbarWidgetColor: Colors.white,
      //     toolbarColor: Color(0xFF0e0e10),
      //     statusBarColor: Color(0xFF0e0e10),
      //     backgroundColor: Colors.white,
      //   ),
      // );
      setState(() {
        selectedImage = fileImage;
      });
    }
  }

  //Image from Camera
  Future captureImageWithCamera() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (fileImage != null) {
      // croppedImage = await ImageCropper.cropImage(
      //   sourcePath: fileImage.path,
      //   aspectRatio: CropAspectRatio(
      //     ratioX: 1,
      //     ratioY: 1,
      //   ),
      //   maxWidth: 700,
      //   maxHeight: 700,
      //   androidUiSettings: AndroidUiSettings(
      //     toolbarTitle: "Crop Image",
      //     toolbarWidgetColor: Colors.white,
      //     toolbarColor: Color(0xFF0e0e10),
      //     statusBarColor: Color(0xFF0e0e10),
      //     backgroundColor: Colors.white,
      //   ),
      // );
      setState(() {
        selectedImage = fileImage;
      });
    }
  }

  // Image Download url
  Future<String> uploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        realTimeReference.child("post_$postId.jpg").putFile(mImageFile);
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
      savePostToIndUserDatabase(
        url: downloadImage,
      );
    } else {
      savePostToDatabase(
        url: "",
      );
      savePostToIndUserDatabase(
        url: "",
      );
    }
  }

  //save to database with url
  savePostToDatabase({String url}) {
    FirebaseFirestore.instance.collection("realTimeTweets").doc(postId).set({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "url": url,
      "likes": [],
      "caption": descController.text,
      "userPic": currentUser.url,
      "commentCount": 0,
      "isVerified": currentUser.isVerified,
      "role": correspondentController.text,
    });
  }

  //User Collection Image
  savePostToIndUserDatabase({String url}) {
    FirebaseFirestore.instance
        .collection("Individual Tweets")
        .doc(currentUser.id)
        .collection("tweets")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "url": url,
      "likes": [],
      "caption": descController.text,
      "userPic": currentUser.url,
      "commentCount": 0,
      "isVerified": currentUser.isVerified,
      "role": correspondentController.text,
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        uploading = false;
        postId = Uuid().v4();
        descController.clear();
        selectedImage = null;
        fileImage = null;
      });
    });
  }
}
