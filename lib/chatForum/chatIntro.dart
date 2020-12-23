import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      ),
      body: CardPageWidget(chatStream: chatStream),
    );
  }
}
