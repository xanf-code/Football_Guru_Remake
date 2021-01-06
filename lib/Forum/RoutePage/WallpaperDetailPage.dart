import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:transfer_news/Forum/Logics/forumLogic.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:provider/provider.dart';

class WallpaperDetailPage extends StatelessWidget {
  final DocumentSnapshot reference;
  const WallpaperDetailPage({Key key, this.reference}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: reference.data()["url"],
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
          Positioned(
            bottom: 20,
            left: 20,
            child: StreamBuilder(
                stream: context
                    .watch<Repository>()
                    .postLikes(reference.data()["postId"]),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.data.exists) {
                    return SizedBox();
                  }
                  return Row(
                    children: [
                      FlatButton.icon(
                        icon: snapshot.data["likes"].contains(currentUser.id)
                            ? Unicon(
                                UniconData.uniFire,
                                color: Colors.blueAccent,
                                size: 19,
                              )
                            : Unicon(
                                UniconData.uniFire,
                                color: Colors.grey,
                                size: 19,
                              ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ForumLogic().likeWallpaper(snapshot.data["postId"]);
                        },
                        label: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  child: child,
                                  scale: animation,
                                );
                              },
                              child: Text(
                                '${NumberFormat.compact().format(snapshot.data["likes"].length)} ',
                                key: ValueKey<String>(
                                    '${NumberFormat.compact().format(snapshot.data["likes"].length)} '),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "Votes",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
          Positioned(
            bottom: 75,
            left: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Unicon(
                  UniconData.uniDownloadAlt,
                  color: Colors.white70,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                    left: 4,
                  ),
                  child: Text(
                    '${NumberFormat.compact().format(reference.data()["downloadCount"])} Downloads',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setWallpaper(wallType, message) async {
    var file =
        await DefaultCacheManager().getSingleFile(reference.data()["url"]);
    await WallpaperManager.setWallpaperFromFile(
      file.path,
      wallType,
    ).whenComplete(() {
      Fluttertoast.showToast(msg: message);
      ForumLogic().incrementDownloadCount(reference.data()["postId"]);
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
