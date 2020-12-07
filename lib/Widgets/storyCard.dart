import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class StoryDesign extends StatelessWidget {
  final String image;
  final String name;
  final bool isUpload;
  StoryDesign({
    this.image,
    this.name,
    this.isUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                height: 59.0,
                width: 59.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xffF58529),
                      Color(0xffFEDA77),
                      Color(0xffDD2A7B),
                      Color(0xff8134AF),
                      Color(0xff515BD4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22.0),
                ),
              ),
              Container(
                height: 55.0,
                width: 55.0,
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(21.0),
                ),
              ),
              Container(
                height: 50.0,
                width: 50.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage.memoryNetwork(
                    fadeInCurve: Curves.easeIn,
                    placeholder: kTransparentImage,
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              isUpload == true
                  ? Icon(
                      Icons.add,
                      color: Colors.white,
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: GoogleFonts.cabin(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
