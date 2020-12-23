import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/chatForum/Widgets/chatCardWidget.dart';
import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';
import 'package:transfer_news/main.dart';
import 'package:uuid/uuid.dart';

class CardPageWidget extends StatefulWidget {
  CardPageWidget({
    @required this.chatStream,
  });

  final Stream chatStream;

  @override
  _CardPageWidgetState createState() => _CardPageWidgetState();
}

class _CardPageWidgetState extends State<CardPageWidget> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupLogoController = TextEditingController();
  TextEditingController groupCoverController = TextEditingController();
  TextEditingController groupBioController = TextEditingController();
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
          return ListView(
            shrinkWrap: true,
            children: [
              currentUser.isAdmin
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[800],
                                content: Container(
                                  height: 500,
                                  width: double.maxFinite,
                                  child: addChatForm(),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFF52b4fa),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Create a Group",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Start a fan group",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Feather.arrow_right,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
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
                      ref: chats.data()["groupID"],
                      titleApp: chats.data()["groupName"],
                      check: chats.data()["official"],
                      bio: chats.data()["groupBio"],
                      users: chats.data()["users"],
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  addChatForm() {
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
            controller: groupBioController,
            decoration: InputDecoration(
              labelText: "Group Bio",
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

  String chatGroupID = Uuid().v4();
  bool isOfficial = false;
  saveToDatabase() {
    FirebaseFirestore.instance
        .collection("ChatsCollection")
        .doc(chatGroupID)
        .set({
      "groupName": groupNameController.text,
      "groupBio": groupBioController.text,
      "groupLogo": groupLogoController.text,
      "groupCover": groupCoverController.text,
      "groupCreatorID": currentUser.id,
      "groupCreatorName": currentUser.username,
      "groupCreatedDateTime": DateTime.now(),
      "official": isOfficial,
      "groupID": chatGroupID,
      "users": [],
      "totalMembers": 0,
    }).whenComplete(() {
      setState(() {
        groupLogoController.clear();
        groupNameController.clear();
        groupBioController.clear();
        chatGroupID = Uuid().v4();
      });
    });
  }
}
