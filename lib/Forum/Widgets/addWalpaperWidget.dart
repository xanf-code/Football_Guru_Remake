import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transfer_news/Forum/Widgets/palette.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';

class AddWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              height: double.infinity,
              width: 110.0,
              fit: BoxFit.cover,
              imageUrl: currentUser.url,
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
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
            child: Text(
              "Add Wallpaper",
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
