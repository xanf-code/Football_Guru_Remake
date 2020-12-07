import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:transfer_news/Forum/RoutePage/PollPage.dart';
import 'package:transfer_news/Forum/RoutePage/forumPage.dart';

class ForumMain extends StatefulWidget {
  final String forumName;
  final List<String> tagName;
  final String appBar;

  const ForumMain({Key key, this.forumName, this.tagName, this.appBar})
      : super(key: key);
  @override
  _ForumMainState createState() => _ForumMainState();
}

class _ForumMainState extends State<ForumMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(
                AntDesign.aliwangwang_o1,
                size: 24,
              ),
              SizedBox(
                width: 15,
              ),
              Text(widget.appBar),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Container(
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  //isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[900],
                  ),
                  tabs: [
                    Tab(
                      text: "Forum",
                    ),
                    Tab(
                      text: "Polls",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ForumDetails(
              forumName: widget.forumName,
              tagName: widget.tagName,
              appBar: widget.appBar,
            ),
            PollPage(
              route: widget.forumName,
            ),
          ],
        ),
      ),
    );
  }
}
