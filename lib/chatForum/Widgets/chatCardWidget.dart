import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/morpheus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/customDialogBox.dart';
import 'package:transfer_news/chatForum/chatPage.dart';
import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';
import 'package:transfer_news/main.dart';

class ChatCardWidget extends StatefulWidget {
  final String logo;
  final String bg;
  final String title;
  final String ref;
  final String titleApp;
  final bool check;
  final String bio;
  var users;
  ChatCardWidget({
    Key key,
    this.users,
    this.logo,
    this.title,
    this.bg,
    this.ref,
    this.titleApp,
    this.check,
    this.bio,
  }) : super(key: key);

  @override
  _ChatCardWidgetState createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  Box<Favourites> favBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favBox = Hive.box<Favourites>(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8,
        top: 8,
      ),
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          if (currentUser.isAdmin) {
            deleteChat();
          }
        },
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 2,
              color: Color(0xFF5c5c5c),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(widget.bg),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: widget.title,
                              descriptions: widget.bio,
                              text: "Done",
                              logo: widget.logo,
                            );
                          },
                        );
                      },
                      child: Icon(
                        Feather.info,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 121,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ProfileAvatar(
                            imageUrl: widget.logo,
                            isActive: true,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  widget.check == true
                                      ? CachedNetworkImage(
                                          height: 18,
                                          imageUrl:
                                              "https://www.freepngimg.com/thumb/youtube/76561-badge-verified-youtube-logo-free-frame.png",
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  widget.bio,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: CircleAvatar(
                                  radius: 14,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://www.timeshighereducation.com/sites/default/files/byline_photos/default-avatar_0.png",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "${NumberFormat.compact().format(widget.users.length)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Members",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              checkEntry();
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
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: widget.users.contains(currentUser.id)
                                  ? Icon(
                                      Feather.arrow_right,
                                      color: Colors.white,
                                    )
                                  : Center(
                                      child: Text(
                                        "Join",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteChat() async {
    await FirebaseFirestore.instance
        .collection("ChatsCollection")
        .doc(widget.ref)
        .delete();
  }

  checkEntry() async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("ChatsCollection")
        .doc(widget.ref)
        .get();
    if (docs.data()['users'].contains(currentUser.id)) {
      return null;
    } else {
      FirebaseFirestore.instance
          .collection("ChatsCollection")
          .doc(widget.ref)
          .update({
        'users': FieldValue.arrayUnion(
          [currentUser.id],
        )
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection("ChatsCollection")
            .doc(widget.ref)
            .update({
          'totalMembers': FieldValue.increment(1),
        });
      });
    }
  }
}
