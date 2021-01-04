import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/RoutePage/WallpaperDetailPage.dart';
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
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          pushNewScreen(
            context,
            withNavBar: false,
            customPageRoute: MorpheusPageRoute(
              builder: (context) => WallpaperDetailPage(
                reference: wallpaper,
              ),
              transitionDuration: Duration(
                milliseconds: 200,
              ),
            ),
          );
        },
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
                imageUrl: wallpaper.data()["userPic"],
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Text(
                wallpaper.data()["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            wallpaper.data()["ownerID"] == currentUser.id
                ? Positioned(
                    top: -5.0,
                    right: -10.0,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      splashRadius: 1,
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        deleteWallpaper(wallpaper.data()["postId"]);
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  deleteWallpaper(postID) {
    FirebaseFirestore.instance
        .collection("wallpaper")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    //Delete Post Pic from Storage
    FirebaseStorage.instance
        .ref()
        .child("Wallpapers")
        .child("post_$postID.jpg")
        .delete();
  }
}
