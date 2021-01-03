import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transfer_news/Forum/Widgets/palette.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';

class WallpaperContainerWidget extends StatelessWidget {
  const WallpaperContainerWidget({
    Key key,
    @required this.wallpaper,
  }) : super(key: key);

  final DocumentSnapshot wallpaper;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: [
          Container(
            height: 200,
            color: appBG,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                height: double.infinity,
                width: 110.0,
                fit: BoxFit.cover,
                imageUrl: wallpaper.data()["url"],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: 110.0,
            decoration: BoxDecoration(
              gradient: Palette.storyGradient,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: ProfileAvatar(
              imageUrl: currentUser.url,
              hasBorder: false,
            ),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
            child: Text(
              currentUser.username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
