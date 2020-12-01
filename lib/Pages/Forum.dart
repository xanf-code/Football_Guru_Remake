import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/allPostWidget.dart';
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
  List<AllPostWidget> allposts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<AllPostWidget> postList = [];
  List<FeaturedPostWidget> featuredPostList = [];

  @override
  void initState() {
    super.initState();
    getLatestPosts();
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

  getLatestPosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await allPostsReference
        .orderBy("timestamp", descending: true)
        .limit(50)
        .get();

    setState(() {
      loading = false;
      postList = querySnapshot.docs
          .map((documentSnapshot) =>
              AllPostWidget.fromDocument(documentSnapshot))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      key: scaffoldKey,
      body: RefreshIndicator(
        child: file == null ? ForumDisplayPage() : displayUploadFormScreen(),
        onRefresh: () async {
          getFeaturedPosts();
          getLatestPosts();
        },
      ),
      floatingActionButton: currentUser.isAdmin == true
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () {
                HapticFeedback.mediumImpact();
                captureImageWithGallery();
              },
              child: Icon(Icons.add),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            )
          : SizedBox(),
    );
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
              createFeed(postList),
            ],
          );
  }

  // Featured Widget
  FeaturedFeed() {
    if (featuredPostList.isEmpty) {
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: featuredPostList,
      ),
    );
  }

  // Non Featured Widget
  createFeed(List item) {
    if (postList.isEmpty) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 300,
                width: 300,
                imageUrl:
                    "https://png.pngtree.com/svg/20161030/nodata_800056.png",
              ),
              Text(
                "oops it's empty :(",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: item,
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

  // Non Featured Posts
  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    String downloadImage = await UploadImage(file);
    savePostToFirestore(
      url: downloadImage,
      title: titleTextEditingController.text,
      desc: result,
      tags: decsTextEditingController.text,
    );

    titleTextEditingController.clear();
    decsTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postID = Uuid().v4();
      result = "";
    });
  }

  savePostToFirestore({String url, String title, String desc, String tags}) {
    allPostsReference.doc(postID).set({
      "postId": postID,
      "ownerID": widget.gCurrentUser.id,
      "timestamp": timeStamp,
      "likes": {},
      "username": widget.gCurrentUser.username,
      "title": title,
      "desc": desc,
      "url": url,
      "tags": tags,
    });
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
                SizedBox(
                  width: 16,
                ),
                FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    final txt = await keyEditor.currentState.getText();
                    setState(() {
                      result = txt;
                    });
                    controllUploadAndSave();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
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
}
