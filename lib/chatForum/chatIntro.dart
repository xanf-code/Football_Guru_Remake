import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:morpheus/morpheus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/chatForum/chatPage.dart';
import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';
import 'package:transfer_news/main.dart';

class ChatIntro extends StatefulWidget {
  @override
  _ChatIntroState createState() => _ChatIntroState();
}

class _ChatIntroState extends State<ChatIntro> with TickerProviderStateMixin {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupLogoController = TextEditingController();
  TextEditingController groupCoverController = TextEditingController();

  Stream chatStream;

  @override
  void initState() {
    super.initState();
    chatStream = chatsReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentUser.isAdmin == true
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[800],
                      content: Container(
                        height: 500,
                        width: double.maxFinite,
                        child: AddChatForm(),
                      ),
                    );
                  },
                );
              },
            )
          : const SizedBox(),
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        title: Text("Discussion Rooms"),
        backgroundColor: Color(0xFF0e0e10),
      ),
      body: CardPageWidget(chatStream: chatStream),
    );
  }

  AddChatForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            controller: groupNameController,
            decoration: InputDecoration(
              labelText: "Group Name",
              labelStyle: GoogleFonts.rubik(color: Colors.white),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          TextFormField(
            controller: groupLogoController,
            decoration: InputDecoration(
              labelText: "Group Logo",
              labelStyle: GoogleFonts.rubik(color: Colors.white),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          TextFormField(
            controller: groupCoverController,
            decoration: InputDecoration(
              labelText: "Group Cover",
              labelStyle: GoogleFonts.rubik(color: Colors.white),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              HapticFeedback.mediumImpact();
              saveToDatabase();
            },
          ),
        ],
      ),
    );
  }

  bool isOfficial = false;
  saveToDatabase() {
    FirebaseFirestore.instance
        .collection("ChatsCollection")
        .doc(groupNameController.text)
        .set({
      "groupName": groupNameController.text,
      "groupLogo": groupLogoController.text,
      "groupCover": groupCoverController.text,
      "groupCreatorID": currentUser.id,
      "groupCreatorName": currentUser.username,
      "groupCreatedDateTime": DateTime.now(),
      "official": isOfficial,
    }).whenComplete(() {
      setState(() {
        groupLogoController.clear();
        groupNameController.clear();
      });
    });
  }
}

class CardPageWidget extends StatefulWidget {
  CardPageWidget({
    Key key,
    @required this.chatStream,
  }) : super(key: key);

  // List<Favourites> favourites;
  final Stream chatStream;

  @override
  _CardPageWidgetState createState() => _CardPageWidgetState();
}

class _CardPageWidgetState extends State<CardPageWidget> {
  Box<Favourites> favBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favBox = Hive.box<Favourites>(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.chatStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length == null
                  ? 0
                  : snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot chats = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: ChatCardWidget(
                    bg: chats.data()["groupCover"],
                    logo: chats.data()["groupLogo"],
                    title: chats.data()["groupName"],
                    ref: chats.data()["groupName"],
                    titleApp: chats.data()["groupName"],
                    check: chats.data()["official"],
                  ),
                );
              },
            );
          }
        });
  }
}

class ChatCardWidget extends StatefulWidget {
  final String logo;
  final String bg;
  final String title;
  final String ref;
  final String titleApp;
  final bool check;
  const ChatCardWidget({
    Key key,
    this.logo,
    this.title,
    this.bg,
    this.ref,
    this.titleApp,
    this.check,
  }) : super(key: key);

  @override
  _ChatCardWidgetState createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  Box<Favourites> favBox;
  // Favourites _favourites;
  // List<Favourites> favouritesList = [];
  // DatabaseController databaseController = DatabaseController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favBox = Hive.box<Favourites>(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        Favourites fav = Favourites(
          title: widget.title,
          logo: widget.logo,
          bg: widget.bg,
          appTitle: widget.titleApp,
          ref: widget.ref,
          isSaved: false,
        );
        favBox.add(fav);
        Fluttertoast.showToast(
          msg: "Shortcut added to Navigation",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8,
              top: 8,
            ),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 2,
                  color: Color(0xFF7232f2),
                ),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: CachedNetworkImageProvider(
                    widget.bg,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.logo,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  widget.check == true
                                      ? CachedNetworkImage(
                                          height: 22,
                                          imageUrl:
                                              "https://i.pinimg.com/originals/42/ad/0e/42ad0ebff37f0625e34df640dc4ae25d.png",
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => ChatPage(
                              reference: widget.ref,
                              title: widget.titleApp,
                              Image: widget.logo,
                              chatScreenContext: context,
                            ),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.35,
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
                                "Enter Chat Room",
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
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
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              color: Color(0xFF7232f2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MaterialIcons.report_problem,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      "Respect everyone, posting inappropriate content will get you IP Banned and further features will be Restricted or Limited.",
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
