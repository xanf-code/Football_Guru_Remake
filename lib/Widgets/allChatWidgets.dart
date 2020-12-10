import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smart_text_view/smart_text_view.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/imageDetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Chats extends StatefulWidget {
  final String userName;
  final String userId;
  final String chat;
  final String url;
  final Timestamp timestamp;
  final likes;
  final String messageID;
  final String reference;
  final String ImageUrl;
  Chats({
    this.userName,
    this.userId,
    this.chat,
    this.url,
    this.timestamp,
    this.likes,
    this.messageID,
    this.reference,
    this.ImageUrl,
  });

  factory Chats.fromDocument(DocumentSnapshot documentSnapshot) {
    return Chats(
      userName: documentSnapshot["username"],
      userId: documentSnapshot["userId"],
      chat: documentSnapshot["chat"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
      likes: documentSnapshot["likes"],
      messageID: documentSnapshot["messageID"],
      reference: documentSnapshot["reference"],
      ImageUrl: documentSnapshot["ImageUrl"],
    );
  }

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final String currentUserOnlineId = currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return currentUserOnlineId != widget.userId
        ? NonCurrentUserChatWidget(
            url: widget.url,
            chat: widget.chat,
            name: widget.userName,
            messageID: widget.messageID,
            ref: widget.reference,
            likes: widget.likes,
            time: widget.timestamp.toDate(),
            ImageUrl: widget.ImageUrl,
          )
        : CurrentUserChatWidget(
            url: widget.url,
            chat: widget.chat,
            name: widget.userName,
            messageID: widget.messageID,
            ref: widget.reference,
            likes: widget.likes,
            time: widget.timestamp.toDate(),
            ImageUrl: widget.ImageUrl,
          );
  }
}

class CurrentUserChatWidget extends StatefulWidget {
  const CurrentUserChatWidget({
    Key key,
    @required this.chat,
    @required this.url,
    this.name,
    this.messageID,
    this.ref,
    this.likes,
    this.time,
    this.ImageUrl,
  }) : super(key: key);
  final likes;
  final String name;
  final String ref;
  final String messageID;
  final String chat;
  final String url;
  final DateTime time;
  final String ImageUrl;

  @override
  _CurrentUserChatWidgetState createState() => _CurrentUserChatWidgetState();
}

class _CurrentUserChatWidgetState extends State<CurrentUserChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SwipeTo(
        onLeftSwipe: () {
          HapticFeedback.mediumImpact();
          removeMessage(widget.ref, widget.messageID);
        },
        iconOnLeftSwipe: MaterialIcons.delete,
        iconColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 45.0,
                bottom: 5,
              ),
              child: Text(
                widget.name,
                style: GoogleFonts.rubik(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    splashRadius: 1,
                    icon: widget.likes.contains(currentUser.id)
                        ? Icon(
                            Ionicons.ios_heart,
                            color: Colors.red,
                          )
                        : Icon(
                            Ionicons.ios_heart,
                            color: Colors.white,
                          ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      like(
                        widget.ref,
                        widget.messageID,
                      );
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        //width: MediaQuery.of(context).size.width / 2,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.5,
                          minWidth: 20.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.grey[900],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.ImageUrl != ""
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          pushNewScreen(
                                            context,
                                            withNavBar: false,
                                            customPageRoute: MorpheusPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                image: widget.ImageUrl,
                                                postID: "",
                                              ),
                                              transitionDuration: Duration(
                                                milliseconds: 130,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 250,
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                widget.ImageUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SmartText(
                                text: widget.chat,
                                onOpen: (url) {
                                  launch(url);
                                },
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                linkStyle: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      widget.likes.length.toString() == 0.toString()
                          ? SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[800],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8,
                                  bottom: 2,
                                  top: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Ionicons.ios_heart,
                                      size: 13,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      widget.likes.length.toString() ==
                                              0.toString()
                                          ? ""
                                          : widget.likes.length.toString(),
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(widget.url),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  removeMessage(String groupName, String messageID) async {
    // Delete Message Collection
    await chatsReference
        .doc(groupName)
        .collection("chats")
        .doc(messageID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    chatImagesReferences.child("post_$messageID.jpg").delete();
  }

  like(String groupName, String messageID) async {
    DocumentSnapshot docs = await chatsReference
        .doc(groupName)
        .collection("chats")
        .doc(messageID)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      chatsReference.doc(groupName).collection("chats").doc(messageID).update({
        'likes': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      chatsReference.doc(groupName).collection("chats").doc(messageID).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}

class NonCurrentUserChatWidget extends StatelessWidget {
  const NonCurrentUserChatWidget({
    Key key,
    @required this.url,
    @required this.chat,
    this.name,
    this.ref,
    this.messageID,
    this.likes,
    this.time,
    this.ImageUrl,
  }) : super(key: key);
  final likes;
  final String url;
  final String chat;
  final String name;
  final String ref;
  final String messageID;
  final DateTime time;
  final String ImageUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 45.0,
              bottom: 5,
            ),
            child: Text(
              name,
              style: GoogleFonts.rubik(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(url),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //width: MediaQuery.of(context).size.width / 2,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                        minWidth: 20.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        //color: Colors.grey[900],
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4e54c8),
                            const Color(0xFF2948ff),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageUrl != ""
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        pushNewScreen(
                                          context,
                                          withNavBar: false,
                                          customPageRoute: MorpheusPageRoute(
                                            builder: (context) => DetailScreen(
                                              image: ImageUrl,
                                              postID: "",
                                            ),
                                            transitionDuration: Duration(
                                              milliseconds: 130,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 250,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              ImageUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SmartText(
                              text: chat,
                              onOpen: (url) {
                                launch(url);
                              },
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              linkStyle: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    likes.length.toString() == 0.toString()
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[800],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8,
                                bottom: 2,
                                top: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Ionicons.ios_heart,
                                    size: 13,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    likes.length.toString(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  splashRadius: 1,
                  splashColor: Colors.transparent,
                  icon: likes.contains(currentUser.id)
                      ? Icon(
                          Ionicons.ios_heart,
                          color: Colors.red,
                        )
                      : Icon(
                          Ionicons.ios_heart,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    like(
                      ref,
                      messageID,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  like(String groupName, String messageID) async {
    DocumentSnapshot docs = await chatsReference
        .doc(groupName)
        .collection("chats")
        .doc(messageID)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      chatsReference.doc(groupName).collection("chats").doc(messageID).update({
        'likes': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      chatsReference.doc(groupName).collection("chats").doc(messageID).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}

class CustomCard extends StatelessWidget {
  final String msg;
  final String additionalInfo;

  CustomCard({@required this.msg, this.additionalInfo = ""});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  //real message
                  TextSpan(
                    text: msg + "    ",
                    style: Theme.of(context).textTheme.subtitle,
                  ),

                  //fake additionalInfo as placeholder
                  TextSpan(
                      text: additionalInfo,
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
                ],
              ),
            ),
          ),

          //real additionalInfo
          Positioned(
            child: Text(
              additionalInfo,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            right: 8.0,
            bottom: 4.0,
          )
        ],
      ),
    );
  }
}
