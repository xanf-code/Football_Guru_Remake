import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidgets extends ChangeNotifier {
  Widget topStories() {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 800),
      slidingCurve: Curves.decelerate,
      delay: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              //bottom: 20,
              top: 12,
              left: 8,
            ),
            child: Text(
              "National Team: Top Stories 🇮🇳",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.grey.shade800,
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget topISL() {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 800),
      slidingCurve: Curves.decelerate,
      delay: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              //bottom: 20,
              top: 20,
              left: 10,
            ),
            child: Text(
              "Indian Super League 🔥",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.grey.shade800,
            height: 15,
          ),
        ],
      ),
    );
  }
}
