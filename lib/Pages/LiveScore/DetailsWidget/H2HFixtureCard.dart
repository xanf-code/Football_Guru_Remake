import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class H2HFixtureCard extends StatefulWidget {
  final String date;
  final String eventVenue;
  final String team1Logo;
  final String team1Name;
  final String team1Score;
  final String team2Logo;
  final String team2Name;
  final String team2Score;

  const H2HFixtureCard({
    Key key,
    this.eventVenue,
    this.team1Logo,
    this.team1Name,
    this.team1Score,
    this.team2Logo,
    this.team2Name,
    this.team2Score,
    this.date,
  }) : super(key: key);
  @override
  _H2HFixtureCardState createState() => _H2HFixtureCardState();
}

class _H2HFixtureCardState extends State<H2HFixtureCard> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                  child: Text(
                    widget.date,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  widget.eventVenue,
                  style: GoogleFonts.rubik(
                    color: Colors.white60,
                  ),
                ),
                Divider(
                  color: Colors.grey[700],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12, bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            height: 30,
                            width: 30,
                            imageUrl:
                                "https://www.fotmob.com/images/team/${widget.team1Logo}",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.team1Name,
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        widget.team1Score.toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            height: 30,
                            width: 30,
                            imageUrl:
                                "https://www.fotmob.com/images/team/${widget.team2Logo}",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.team2Name,
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        widget.team2Score.toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
