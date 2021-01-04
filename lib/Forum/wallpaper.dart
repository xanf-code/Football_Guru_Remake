import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'Widgets/StoryScrollWidget.dart';

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
