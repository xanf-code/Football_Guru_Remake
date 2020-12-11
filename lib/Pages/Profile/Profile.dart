import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/Profile/privacypolicies.dart';
import 'package:transfer_news/Pages/Profile/terms&cond.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/UsersRealTimePosts/usersRTPosts.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  const ProfilePage({Key key, this.userProfileId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  File selectedImage;
  File fileImage;
  File croppedImage;
  bool uploading = false;
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.id)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        var userDocument = snapshot.data;
                        return Container(
                          child: Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        userDocument["photoUrl"],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          updateProfileImage();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: tagBorder,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Feather.edit_3,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      userDocument["username"],
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Feather.edit_2,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        displayDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF0e0e10),
                                title: Text(
                                  "Socials",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        launch(
                                            "https://www.instagram.com/iftwc_/");
                                      },
                                      child: Row(
                                        children: [
                                          Unicon(
                                            UniconData.uniInstagramAlt,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "Instagram",
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        launch(
                                            "https://www.facebook.com/IFTWC/");
                                      },
                                      child: Row(
                                        children: [
                                          Unicon(
                                            UniconData.uniFacebookF,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "Facebook",
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        launch("https://twitter.com/iftwc");
                                      },
                                      child: Row(
                                        children: [
                                          Unicon(
                                            UniconData.uniTwitterAlt,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "Twitter",
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        launch(
                                            "https://www.youtube.com/channel/UCzrGZMoQE_XrnAj7HEM1tRw");
                                      },
                                      child: Row(
                                        children: [
                                          Unicon(
                                            UniconData.uniYoutube,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "Youtube",
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ProfileWidget(
                          title: "Socials",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MorpheusPageRoute(
                              builder: (context) => PolicyPage(),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                        child: ProfileWidget(
                          title: "Privacy Policy",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MorpheusPageRoute(
                              builder: (context) => termsAndCond(),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                        child: ProfileWidget(
                          title: "Terms And Condition",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          launch(
                              "https://play.google.com/store/apps/details?id=com.indianfootball.transfer_news");
                        },
                        child: ProfileWidget(title: "Playstore"),
                      ),
                    ),
                    currentUser.isAdmin == false
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => RealTimePostsMade(),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ProfileWidget(title: "Real Time Posts"),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.cached,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Cache Management",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF0e0e10),
                                title: Text(
                                  "Cache Manager",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Text(
                                  "Are you sure you want to clear all app cache?",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () async {
                                      HapticFeedback.mediumImpact();
                                      DefaultCacheManager manager =
                                          new DefaultCacheManager();
                                      await manager.emptyCache();
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                        msg: "Cache Cleared",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0,
                                      );
                                    },
                                    child: Text("Clear"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close"),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ProfileWidget(
                          title: "Clear Cache",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: FlatButton(
                        color: Color(0xFF7232f2),
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          logOutUser();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "SIGN OUT",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          selectedImage != null && croppedImage != null
              ? Stack(
                  children: [
                    ClipRRect(
                      child: BackdropFilter(
                        filter:
                            new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.file(selectedImage),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          selectedImage = null;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            controlUploadAndSave();
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF396afc),
                                  const Color(0xFF2948ff),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                              ),
                            ),
                            child: Center(
                              child: uploading == false
                                  ? Text(
                                      "Update",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Visibility(visible: false, child: const SizedBox.shrink()),
        ],
      ),
    );
  }

  final _formFieldKey = GlobalKey<FormFieldState>();

  displayDialog(BuildContext context) async {
    return showDialog(
        useRootNavigator: true,
        context: context,
        builder: (context) {
          return Form(
            key: _formFieldKey,
            child: AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Enter New Username',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: textFieldController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Feather.user,
                    color: Colors.white,
                  ),
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "New Username here",
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Submit'),
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    textFieldController.text != ""
                        ? await FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.id)
                            .update({
                            "username": textFieldController.text,
                          }).whenComplete(() {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: "Username Updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            );
                            setState(() {
                              textFieldController.clear();
                            });
                          })
                        : Fluttertoast.showToast(
                            msg: "Username cannot be empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0,
                          );
                  },
                )
              ],
            ),
          );
        });
  }

  Future updateProfileImage() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fileImage != null) {
      croppedImage = await ImageCropper.cropImage(
        sourcePath: fileImage.path,
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
        selectedImage = fileImage;
      });
    }
  }

  String postId = Uuid().v4();
  // Image Download url
  Future<String> uploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        profilePicsReference.child("post_$postId.jpg").putFile(mImageFile);
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
      savePostToUserDatabase(
        downloadImage,
      );
    }
  }

  savePostToUserDatabase(String url) {
    FirebaseFirestore.instance.collection("users").doc(currentUser.id).update({
      "photoUrl": url,
    }).whenComplete(() {
      setState(() {
        uploading = false;
        selectedImage = null;
      });
    });
  }

  logOutUser() {
    gSignIn.signOut();
  }
}

class ProfileWidget extends StatelessWidget {
  final String title;
  const ProfileWidget({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[300],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
      ],
    );
  }
}
