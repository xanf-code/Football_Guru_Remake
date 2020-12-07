import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Cards extends StatelessWidget {
  final String image;
  final String title;
  final String views;
  final String tags;
  const Cards({
    Key key,
    this.image,
    this.title,
    this.views,
    this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF0e0e10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 110,
                  width: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      useOldImageOnUrlChange: true,
                      imageUrl: image,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 2.0,
                            bottom: 2,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            tags.toUpperCase(),
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Ionicons.md_eye,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            views,
                            style: GoogleFonts.openSans(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                AntDesign.right,
                color: Colors.indigoAccent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
