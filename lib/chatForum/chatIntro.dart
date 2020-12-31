import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/chatForum/Widgets/chatPageWidget.dart';

class ChatIntro extends StatefulWidget {
  @override
  _ChatIntroState createState() => _ChatIntroState();
}

class _ChatIntroState extends State<ChatIntro> with TickerProviderStateMixin {
  Stream chatStream;

  @override
  void initState() {
    super.initState();
    chatStream = chatsReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        title: Text("Discussion Rooms"),
        backgroundColor: Color(0xFF0e0e10),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: IconButton(
              splashRadius: 1,
              splashColor: Colors.transparent,
              icon: Unicon(
                UniconData.uniInfoCircle,
                color: Colors.white,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text(
                        "Info",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        "• Get your own chat rooms, to do so contact admins on our Instagram/Facebook/Twitter page.",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: CardPageWidget(chatStream: chatStream),
    );
  }
}
