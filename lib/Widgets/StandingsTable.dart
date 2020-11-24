import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class StandingWidget extends StatefulWidget {
  final String name;
  final String logo;
  final String played;
  final String won;
  final String draw;
  final String lost;
  final String points;
  const StandingWidget(
      {Key key,
      this.name,
      this.logo,
      this.played,
      this.won,
      this.draw,
      this.lost,
      this.points})
      : super(key: key);
  @override
  _ExampleOnlyState createState() => _ExampleOnlyState();
}

class _ExampleOnlyState extends State<StandingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Octicons.dash,
                  size: 12,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    CachedNetworkImage(
                      height: 20,
                      width: 20,
                      imageUrl: widget.logo == ""
                          ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                          : widget.logo,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        widget.name,
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.played.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.won.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.draw.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.lost.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.points.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StandingsTopWidget extends StatelessWidget {
  const StandingsTopWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Team',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PL',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'W',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'D',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'L',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Pts',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
