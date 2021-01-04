import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/RoutePage/addWallpaper.dart';
import 'package:transfer_news/Forum/Widgets/palette.dart';
import 'package:transfer_news/Pages/home.dart';

class WallWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          pushNewScreen(
            context,
            withNavBar: false,
            customPageRoute: MorpheusPageRoute(
              builder: (context) => AddNewWallpaper(),
              transitionDuration: Duration(
                milliseconds: 200,
              ),
            ),
          );
        },
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
      ),
    );
  }
}
