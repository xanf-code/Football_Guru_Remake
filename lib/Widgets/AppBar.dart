import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableWidgets {
  static getAppBar(String title, String url, Color colors) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CachedNetworkImage(
                imageUrl: url,
                //color: colors,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
