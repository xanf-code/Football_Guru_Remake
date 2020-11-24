import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:story_designer/story_designer.dart';
import 'package:transfer_news/Model/storiesModel.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  const UploadPage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

// createStories(
//   String name,
//   String ownerID,
//   String postId,
//   String url,
// ) async {
//   Map<String, dynamic> data = {
//     "name": name,
//     "ownerID": ownerID,
//     "postId": postId,
//     "url": url,
//   };
//   String jsonBody = json.encode(data);
//   final headers = {'Content-Type': 'application/json'};
//   final String apiUrl =
//       "https://storiesbackendapi.herokuapp.com/api/postStories";
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

class _UploadPageState extends State<UploadPage> {
  File selectedImage;
  String postId = Uuid().v4();
  bool uploading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool official = false;
  TextEditingController captionEditor = TextEditingController();

  Future captureImageWithGallery() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
    ).then((file) async {
      var editedFile = await pushNewScreen(
        context,
        withNavBar: false,
        customPageRoute: MorpheusPageRoute(
          builder: (context) => StoryDesigner(
            filePath: file.path,
          ),
          transitionDuration: Duration(
            milliseconds: 200,
          ),
        ),
      );
      setState(() {
        selectedImage = editedFile;
      });
    });
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
    //@Firebase
    savePostToFirestore(
      url: downloadImage,
    );

    //@API POST http://127.0.0.1:5000/api/postStories
    // createStories(
    //         currentUser.username, widget.gCurrentUser.id, postId, downloadImage)
    //     .then((result) {
    //   Navigator.pop(context);
    //   setState(() {
    //     selectedImage = null;
    //     uploading = false;
    //     postId = Uuid().v4();
    //   });
    // });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        title: Text("Upload Story"),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              selectedImage = null;
              Navigator.pop(context);
            });
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xFF0e0e10),
      ),
      body: ListView(
        children: [
          uploading ? LinearProgressIndicator() : Text(""),
          selectedImage != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        bottom: 10,
                      ),
                      child: TextFormField(
                        controller: captionEditor,
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
                      onTap: () async {
                        await controllUploadAndSave();
                      },
                      //uploading ? null : () => var resp = await controllUploadAndSave(),
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
                                "Upload Story",
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
                )
              : Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.upload_file),
                        onPressed: () {
                          captureImageWithGallery();
                        },
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
