import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:realtime_pagination/realtime_pagination.dart';
import 'package:transfer_news/Forum/Widgets/addWalpaperWidget.dart';
import 'package:transfer_news/Forum/Widgets/palette.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Utils/constants.dart';

import 'Widgets/wallpaperWidget.dart';

class WallpaperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            bottom: 12,
          ),
          child: Text(
            "Wallpapers",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200,
          color: appBG,
          child: StoryWidget(),
        ),
      ],
    );
  }
}

class StoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          WallWidget(),
          StreamBuilder(
            stream: Provider.of<Repository>(
              context,
            ).getWallpaper("wallpaper"),
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
