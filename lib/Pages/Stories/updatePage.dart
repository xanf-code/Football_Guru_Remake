import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:story_designer/story_designer.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/ISLNews.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/storyCard.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  const UploadPage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File selectedImage;
  File fileImage;
  String postId = Uuid().v4();
  bool uploading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool official = false;
  TextEditingController captionEditor = TextEditingController();

  Future captureImageWithGallery() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fileImage != null) {
      File editedFile = await Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => StoryDesigner(
            filePath: fileImage.path,
          ),
        ),
      );
      setState(() {
        selectedImage = editedFile;
      });
    }
  }

  Future captureImageWithCamera() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (fileImage != null) {
      File editedFile = await Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => StoryDesigner(
            filePath: fileImage.path,
          ),
        ),
      );
      setState(() {
        selectedImage = editedFile;
      });
    }
  }

  Future<String> uploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storyReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    String downloadImage = await uploadImage(selectedImage);
    savePostToFirestore(
      url: downloadImage,
    );
    savePostToFirestoreIndividual(
      url: downloadImage,
    );
  }

  savePostToFirestore({String url}) {
    FirebaseFirestore.instance.collection("stories").doc(postId).set({
      "postId": postId,
      "ownerID": widget.gCurrentUser.id,
      "timestamp": timeStamp,
      "name": currentUser.username,
      "url": url,
      "official": official,
      "caption": captionEditor.text,
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        selectedImage = null;
        uploading = false;
        postId = Uuid().v4();
      });
    });
  }

  savePostToFirestoreIndividual({String url}) {
    FirebaseFirestore.instance
        .collection("RecentStories")
        .doc(currentUser.id)
        .collection("Alltories")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerID": widget.gCurrentUser.id,
      "timestamp": timeStamp,
      "name": currentUser.username,
      "url": url,
      "official": official,
      "caption": captionEditor.text,
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        selectedImage = null;
        uploading = false;
        postId = Uuid().v4();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: Stack(
          children: [
            fileImage != null && selectedImage != null
                ? Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Image.file(
                            selectedImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 60,
                                child: TextFormField(
                                  controller: captionEditor,
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
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await controllUploadAndSave();
                                },
                                //uploading ? null : () => var resp = await controllUploadAndSave(),
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
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      DelayedDisplay(
                        slidingBeginOffset: Offset(-1, 1),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 16,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                                height: 64.0,
                                width: 64.0,
                                decoration: BoxDecoration(
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
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 16,
                              ),
                              child: Text(
                                "Upload\nStory",
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DelayedDisplay(
                        slidingBeginOffset: Offset(2, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              captureImageWithGallery();
                            },
                            child: Container(
                              height: 100,
                              color: Colors.black,
                              child: Center(
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    imageUrl:
                                        "https://assets.materialup.com/uploads/4e1c044a-3d04-4f2d-ae59-9897e895a744/preview",
                                  ),
                                  trailing: Icon(
                                    Ionicons.ios_arrow_forward,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    "Pick Image From Gallery",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        slidingBeginOffset: Offset(3, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              captureImageWithCamera();
                            },
                            child: Container(
                              height: 100,
                              color: Colors.black,
                              child: Center(
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    imageUrl:
                                        "https://icon-library.com/images/material-design-camera-icon/material-design-camera-icon-3.jpg",
                                  ),
                                  trailing: Icon(
                                    Ionicons.ios_arrow_forward,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    "Capture Image with Camera",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 25,
                          left: 25,
                        ),
                        child: Text(
                          "My Stories",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      buildStories(),
                      DelayedDisplay(
                        child: guidelines(),
                      ),
                      DelayedDisplay(
                        child: guidelinesText(),
                      ),
                    ],
                  ),
            uploading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  Padding guidelinesText() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        top: 12,
        right: 12,
      ),
      child: Column(
        children: [
          Text(
            "- You are responsible for any activity that occurs under your screen name.",
            style: GoogleFonts.rubik(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "- You must not post nude, partially nude, or sexually suggestive photos on Football Guru.",
            style: GoogleFonts.rubik(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "- You must not abuse, harass, threaten, impersonate or intimidate other users.",
            style: GoogleFonts.rubik(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "- You must not create or submit unwanted photos to any other members.",
            style: GoogleFonts.rubik(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "- You must not, in the use of Football Guru, violate any laws in your jurisdiction (including but not limited to copyright laws).",
            style: GoogleFonts.rubik(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Padding guidelines() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        top: 25,
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            Ionicons.ios_information_circle_outline,
            color: Colors.grey,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "Stories Guidelines",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  buildStories() {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 500),
      slidingCurve: Curves.decelerate,
      delay: Duration(milliseconds: 100),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("RecentStories")
            .doc(currentUser.id)
            .collection("Alltories")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 12,
              ),
              child: Container(
                height: 200,
                //color: Colors.indigo,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length == null
                      ? 0
                      : snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data == null) {
                      return SizedBox();
                    } else {
                      return InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MorpheusPageRoute(
                              builder: (context) => StoryPage(
                                url: snapshot.data.docs[index]["url"],
                                caption: snapshot.data.docs[index]["caption"],
                              ),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 150,
                              height: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  width: 150,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  image: snapshot.data.docs[index]["url"],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black45, Colors.black38],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              left: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  MaterialCommunityIcons.delete,
                                  color: Colors.white,
                                ),
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  removeStory(
                                      snapshot.data.docs[index]["postId"]);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  removeStory(postID) async {
    FirebaseFirestore.instance
        .collection("RecentStories")
        .doc(currentUser.id)
        .collection("Alltories")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    storyReference.child("post_$postID.jpg").delete();

    FirebaseFirestore.instance
        .collection("stories")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }
}
