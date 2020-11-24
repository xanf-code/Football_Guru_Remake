import 'package:flutter/material.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;

  const CustomAppBar({Key key, this.scrollOffset = 0.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 24,
      ),
      color: Colors.black.withOpacity(
        (scrollOffset / 350).clamp(0, 1).toDouble(),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => launch(
                "https://www.youtube.com/channel/UCzrGZMoQE_XrnAj7HEM1tRw",
              ),
              child: Unicon(
                UniconData.uniYoutube,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Text(
              "Exclusives",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
