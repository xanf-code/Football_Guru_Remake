import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperDetailPage extends StatelessWidget {
  final String image;

  const WallpaperDetailPage({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.wallpaper,
                color: Colors.black,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                modalSheet(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setWallpaper(wallType, message) async {
    var file = await DefaultCacheManager().getSingleFile(image);
    await WallpaperManager.setWallpaperFromFile(
      file.path,
      wallType,
    ).whenComplete(() {
      Fluttertoast.showToast(msg: message);
    });
  }

  modalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appBG,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: 170,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Set Lock Screen Wallpaper",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  Icons.phonelink_lock_sharp,
                  color: Colors.white,
                ),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setWallpaper(WallpaperManager.LOCK_SCREEN,
                      "Lock Screen wallpaper set");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Set Home Screen Wallpaper",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setWallpaper(WallpaperManager.HOME_SCREEN,
                      "Home Screen wallpaper set");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Set Both Screens Wallpaper",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  Icons.wallpaper,
                  color: Colors.white,
                ),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setWallpaper(WallpaperManager.BOTH_SCREENS,
                      "Home Screen and Lock Screen wallpaper set");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
