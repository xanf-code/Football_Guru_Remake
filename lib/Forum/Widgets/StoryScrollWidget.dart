import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transfer_news/Forum/Widgets/addWalpaperWidget.dart';
import 'package:transfer_news/Forum/Widgets/wallpaperWidget.dart';
import 'package:transfer_news/Repo/repo.dart';

class StoryWidget extends StatefulWidget {
  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final ScrollController _scrollController = ScrollController();
  int _limit = 4;
  final int _limitIncrement = 10;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          WallWidget(),
          StreamBuilder(
            stream: Provider.of<Repository>(
              context,
            ).getWallpaper("wallpaper", _limit),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot wallpaper = snapshot.data.docs[index];
                    return WallpaperContainerWidget(wallpaper: wallpaper);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
