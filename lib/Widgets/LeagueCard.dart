import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeagueCard extends StatefulWidget {
  final String leagueLogo;
  final String leagueName;
  final String leagueYear;
  final String evenName;
  final String eventVenue;
  final String team1Logo;
  final String team1Name;
  final String team1Score;
  final String team2Logo;
  final String team2Name;
  final String team2Score;
  final int index;

  const LeagueCard(
      {Key key,
      this.leagueLogo,
      this.leagueName,
      this.leagueYear,
      this.evenName,
      this.eventVenue,
      this.team1Logo,
      this.team1Name,
      this.team1Score,
      this.team2Logo,
      this.team2Name,
      this.team2Score,
      this.index})
      : super(key: key);
  @override
  _LeagueCardState createState() => _LeagueCardState();
}

class _LeagueCardState extends State<LeagueCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: CachedNetworkImage(
                  color: Colors.white,
                  imageUrl: widget.leagueLogo,
                  height: 50,
                  width: 50,
                ),
                title: Text(
                  widget.leagueName,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  widget.leagueYear,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                  ),
                ),
              ),
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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: Text(
                              widget.evenName,
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
                                      imageUrl: widget.team1Logo,
                                    ),
                                    SizedBox(
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
                                      imageUrl: widget.team2Logo,
                                    ),
                                    SizedBox(
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                  bottom: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "See Standings",
                      style: GoogleFonts.rubik(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
