import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Forum/RoutePage/forumPage.dart';
import 'package:transfer_news/Forum/cardWidget.dart';
import 'package:transfer_news/Forum/main.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:transfer_news/Widgets/featuredPostWidget.dart';
import 'package:uuid/uuid.dart';

class Forum extends StatefulWidget {
  final User gCurrentUser;

  const Forum({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  File file;
  String postID = Uuid().v4();
  bool uploading = false;
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController decsTextEditingController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<FeaturedPostWidget> featuredPostList = [];

  @override
  void initState() {
    super.initState();
    getFeaturedPosts();
  }

  getFeaturedPosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await featuredPostsReference
        .orderBy("timestamp", descending: true)
        .limit(50)
        .get();

    setState(() {
      loading = false;
      featuredPostList = querySnapshot.docs
          .map((documentSnapshot) =>
              FeaturedPostWidget.fromDocument(documentSnapshot))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          actions: [
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 40,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => ProfilePage(
                        userProfileId: currentUser.id,
                      ),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.gCurrentUser.url),
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Color(0xFF0e0e10),
          centerTitle: false,
          title: Text(
            'Forum',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: RefreshIndicator(
          child: file == null ? ForumDisplayPage() : displayUploadFormScreen(),
          onRefresh: () async {
            getFeaturedPosts();
          },
        ),
        floatingActionButton: Visibility(
          visible: currentUser.isAdmin == true && currentUser.isVerified == true
              ? true
              : false,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              HapticFeedback.mediumImpact();
              captureImageWithGallery();
            },
            child: Icon(Icons.add),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ));
  }

  ForumDisplayPage() {
    return loading
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  width: 170,
                  height: 170,
                  imageUrl:
                      "https://i.pinimg.com/originals/79/04/42/7904424933cc535b666f2de669973530.gif",
                ),
                Positioned(
                  bottom: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.blueAccent,
                    child: Text(
                      'Building Feed 🔥',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              FeaturedFeed(),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Forum")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => ForumMain(
                                    length: 2,
                                    forumName: "National Team",
                                    tagName: NTTags,
                                    appBar: "National Team",
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                              viewCounter("National Team");
                            },
                            child: Cards(
                              title: "National Teams Discussion 🇮🇳 ⚽",
                              image:
                                  "https://news.cgtn.com/news/3d3d674e3241444e7a457a6333566d54/img/6513d5354b04433a9512a2b1f521465c/6513d5354b04433a9512a2b1f521465c.jpg",
                              views:
                                  "${snapshot.data.docs[2]["counter"].length} Views",
                              tags: "National Team",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => ForumMain(
                                    length: 4,
                                    forumName: "ISL",
                                    tagName: ISLTags,
                                    appBar: "Indian Super League",
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                              viewCounter("ISL");
                            },
                            child: Cards(
                              title: "Indian Super League 🏆",
                              image:
                                  "https://www.footballteamnews.com/img/news/news_5aafc5a78b3e5.JPEG",
                              views:
                                  "${snapshot.data.docs[1]["counter"].length} Views",
                              tags: "Domestic Leagues",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => ForumMain(
                                    length: 2,
                                    forumName: "I-League",
                                    tagName: IleagueTags,
                                    appBar: "I-League",
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                              viewCounter("I-League");
                            },
                            child: Cards(
                              title: "I-League 🏅⚽",
                              image:
                                  "https://images.daznservices.com/di/library/GOAL/1d/cb/i-league-trophy_12jv1cp4di6vk17y4zcone0ndz.jpg?t=150978242&quality=60&w=1200&h=800",
                              views:
                                  "${snapshot.data.docs[0]["counter"].length} Views",
                              tags: "I-League",
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ],
          );
  }

  // Featured Widget
  FeaturedFeed() {
    if (featuredPostList.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: featuredPostList,
      ),
    );
  }

  captureImageWithGallery() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      maxWidth: 700,
      maxHeight: 700,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
        toolbarColor: Color(0xFF0e0e10),
        statusBarColor: Color(0xFF0e0e10),
        backgroundColor: Colors.white,
      ),
    );
    setState(() {
      this.file = croppedImage;
    });
  }

  removeImage() {
    titleTextEditingController.clear();
    decsTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  Future<String> UploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$postID.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Featured Posts
  controllUploadAndSaveFeatured() async {
    setState(() {
      uploading = true;
    });
    String downloadImage = await UploadImage(file);
    savePostToFirestoreFeatured(
      url: downloadImage,
      title: titleTextEditingController.text,
      desc: result,
    );

    titleTextEditingController.clear();
    //decsTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postID = Uuid().v4();
      result = "";
    });
  }

  savePostToFirestoreFeatured({String url, String title, String desc}) {
    featuredPostsReference.doc(postID).set({
      "postId": postID,
      "ownerID": widget.gCurrentUser.id,
      "timestamp": timeStamp,
      "likes": {},
      "tags": "FEATURED",
      "username": widget.gCurrentUser.username,
      "title": title,
      "desc": desc,
      "url": url,
    });
  }

  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text("Go Back"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              file = null;
            });
          },
        ),
      ),
      backgroundColor: Color(0xFF0e0e10),
      body: ListView(
        children: [
          uploading ? LinearProgressIndicator() : Text(""),
          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                maxLength: 60,
                maxLengthEnforced: true,
                controller: titleTextEditingController,
                style: GoogleFonts.ubuntu(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Title Here",
                  hintStyle: GoogleFonts.ubuntu(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.ubuntu(
                  color: Colors.white,
                ),
                controller: decsTextEditingController,
                decoration: InputDecoration(
                  hintText: "Tag Here",
                  hintStyle: GoogleFonts.ubuntu(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          HtmlEditor(
            hint: "Your text here...",
            //value: "text content initial, if any",
            key: keyEditor,
            height: 500,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    setState(() {
                      keyEditor.currentState.setEmpty();
                    });
                  },
                  child: Text("Reset", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  width: 16,
                ),
                FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    final txt = await keyEditor.currentState.getText();
                    setState(() {
                      result = txt;
                    });
                    controllUploadAndSaveFeatured();
                  },
                  child: Text(
                    "Submit Featured",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  viewCounter(String docName) async {
    await FirebaseFirestore.instance.collection("Forum").doc(docName).update({
      'counter': FieldValue.arrayUnion(
        [currentUser.id],
      )
    });
  }
}
