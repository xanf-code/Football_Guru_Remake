import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class StandingsDetails extends StatelessWidget {
  final String name;
  final int image;
  final String played;
  final String won;
  final String lost;
  final String draw;
  final String gf;
  final String ga;
  final String gd;
  final String points;
  final String currentPosition;
  final String prevPosition;
  const StandingsDetails({
    Key key,
    this.name,
    this.image,
    this.played,
    this.won,
    this.lost,
    this.draw,
    this.gf,
    this.ga,
    this.gd,
    this.points,
    this.currentPosition,
    this.prevPosition,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text(name),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: CachedNetworkImage(
              height: 200,
              imageUrl:
                  "https://www.indiansuperleague.com/static-resources/images/clubs/small/$image.png?v=1.92",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 30,
            ),
            child: Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    width: 1,
                    color: Color(0xFF7232f2),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPosition,
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      currentPosition.compareTo(prevPosition) == -1
                          ? Icon(
                              Ionicons.ios_arrow_up,
                              color: Colors.green,
                            )
                          : currentPosition.compareTo(prevPosition) == 0
                              ? Icon(
                                  Octicons.dash,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Ionicons.ios_arrow_down,
                                  color: Colors.red,
                                ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Boxes(
                      type: "Played",
                      stat: played,
                    ),
                    Boxes(
                      type: "Won",
                      stat: won,
                    ),
                    Boxes(
                      type: "Lost",
                      stat: lost,
                    ),
                    Boxes(
                      type: "Draw",
                      stat: draw,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Boxes(
                      type: "GF",
                      stat: gf,
                    ),
                    Boxes(
                      type: "GA",
                      stat: ga,
                    ),
                    Boxes(
                      type: "GD",
                      stat: gd,
                    ),
                    Boxes(
                      type: "Points",
                      stat: points,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Boxes extends StatelessWidget {
  final String type;
  final String stat;
  const Boxes({
    Key key,
    this.type,
    this.stat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          type,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 1,
              color: Color(0xFF7232f2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              stat,
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
