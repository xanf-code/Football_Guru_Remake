import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryPage extends StatelessWidget {
  final storyController = StoryController();
  final String url;
  final String caption;
  final String userName;
  final String userPic;
  final String viewCount;
  StoryPage({
    Key key,
    this.url,
    this.caption,
    this.userName,
    this.userPic,
    this.viewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: StoryView(
              controller: storyController,
              storyItems: [
                StoryItem.pageImage(
                  duration: Duration(
                    seconds: 10,
                  ),
                  url: url,
                  caption: caption,
                  controller: storyController,
                ),
              ],
              onComplete: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 15,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userPic),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            child: Row(
              children: [
                Unicon(
                  UniconData.uniEye,
                  color: Colors.white70,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "$viewCount Views",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
