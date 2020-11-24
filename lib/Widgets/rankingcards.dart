import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingCards extends StatelessWidget {
  final String type;
  final String rank;
  final IconData iconType;
  const RankingCards({Key key, this.type, this.rank, this.iconType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 12,
        right: 12,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: GoogleFonts.rubik(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    iconType,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    rank,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
