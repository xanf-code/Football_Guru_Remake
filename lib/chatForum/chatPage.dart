import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/allChatWidgets.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String reference;
  final String title;
  final String Image;
  final BuildContext chatScreenContext;

  const ChatPage(
      {Key key, this.reference, this.title, this.Image, this.chatScreenContext})
      : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatTextEditingController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final _controller = ScrollController();
  String msgID = Uuid().v4();
  File selectedImage;
  File fileImage;
  bool uploading = false;

  final ScrollController _scrollController = ScrollController();
  int _limit = 13;
  final int _limitIncrement = 20;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  displayChats() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("ChatsCollection")
          .doc(widget.reference)
          .collection("chats")
          .orderBy("timestamp", descending: true)
          .limit(_limit)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Chats> chats = [];
        dataSnapshot.data.documents.forEach(
          (document) {
            chats.add(Chats.fromDocument(document));
          },
        );
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            reverse: true,
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            children: chats,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(
                widget.Image,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.title),
          ],
        ),
      ),
      body: selectedImage == null
          ? Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: displayChats(),
                  ),
                  ListTile(
                    title: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be empty!";
                        } else {
                          return null;
                        }
                      },
                      controller: chatTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: GoogleFonts.rubik(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            borderSide: BorderSide.none),
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            saveChat(url: "");
                          }
                        });
                        //FocusScope.of(context).unfocus();
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _controller.animateTo(
                            _controller.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF3366FF),
                              const Color(0xFF00CCFF),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            FontAwesome.send_o,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        captureImageWithGallery();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF3366FF),
                              const Color(0xFF00BCFF),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Feather.image,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: displayChats(),
                      ),
                      ListTile(
                        title: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "This field cannot be empty!";
                            } else {
                              return null;
                            }
                          },
                          controller: chatTextEditingController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: GoogleFonts.rubik(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                borderSide: BorderSide.none),
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_formKey.currentState.validate()) {
                                controlUploadAndSave();
                              }
                            });
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _controller.animateTo(
                                _controller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            });
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: new LinearGradient(
                                colors: [
                                  const Color(0xFF3366FF),
                                  const Color(0xFF00CCFF),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                FontAwesome.send_o,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        leading: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            captureImageWithGallery();
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: new LinearGradient(
                                colors: [
                                  const Color(0xFF3366FF),
                                  const Color(0xFF00BCFF),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Feather.image,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 70,
                  left: 20,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 100,
                        color: Colors.white,
                        child: Card(
                          color: Colors.white,
                          child: Container(
                            height: 80,
                            width: 80,
                            color: Colors.black,
                            child: Image.file(selectedImage),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              selectedImage = null;
                            });
                          },
                        ),
                      ),
                      uploading
                          ? Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future captureImageWithGallery() async {
    fileImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fileImage != null) {
      setState(() {
        selectedImage = fileImage;
      });
    }
  }

  Future<String> uploadImage(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        chatImagesReferences.child("message_$msgID.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // selected image null
  saveChat({String url}) {
    FirebaseFirestore.instance
        .collection("ChatsCollection")
        .doc(widget.reference)
        .collection("chats")
        .doc(msgID)
        .set({
      "username": currentUser.username,
      "chat": chatTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "likes": [],
      "userId": currentUser.id,
      "messageID": msgID,
      "reference": widget.reference,
      "ImageUrl": url,
    });
    setState(() {
      chatTextEditingController.clear();
      msgID = Uuid().v4();
      selectedImage = null;
      uploading = false;
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    if (selectedImage != null) {
      String downloadImage = await uploadImage(selectedImage);
      saveChat(
        url: downloadImage,
      );
    } else {
      saveChat(
        url: "",
      );
    }
  }
}
