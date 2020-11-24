import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:transfer_news/Youtube/contentHeader.dart';
import 'package:transfer_news/Youtube/customAppBar.dart';
import 'package:transfer_news/Youtube/widget/contentList.dart';

class techtroYoutube extends StatefulWidget {
  @override
  _techtroYoutubeState createState() => _techtroYoutubeState();
}

class _techtroYoutubeState extends State<techtroYoutube> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
        child: CustomAppBar(
          scrollOffset: _scrollOffset,
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ContentHeader(),
          ),
          SliverPadding(
            sliver: SliverToBoxAdapter(
              child: ContentList(
                title: "Techtro Exclusives",
                urlPath: "https://techtrofootball.herokuapp.com/",
              ),
            ),
            padding: EdgeInsets.only(
              top: 12,
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Specials",
              urlPath: "https://specialstechtro.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Top 5's",
              urlPath: "https://top5techtro.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "National Team",
              urlPath: "https://nationalteam.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Know Your Hero",
              urlPath: "https://knowyourheroes.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Tactical Analysis",
              urlPath: "https://tacticalanalysis.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Highlights",
              urlPath: "https://highlightslive.herokuapp.com/",
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: "Project Adamas",
              urlPath: "https://projectadamas.herokuapp.com/",
            ),
          ),
        ],
      ),
      //backgroundColor: Color(0xFF0e0e10),
    );
  }
}
