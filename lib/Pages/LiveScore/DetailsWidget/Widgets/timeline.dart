import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({
    Key key,
    @required this.matchFacts,
  }) : super(key: key);

  final List matchFacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: matchFacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: TimelineTile(
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 45,
                height: 45,
                indicator: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        matchFacts[index]["timeStr"],
                        style: GoogleFonts.dosis(
                          //fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                drawGap: true,
              ),
              //lineXY: 0.3,
              endChild: matchFacts[index]["isHome"] == false &&
                      matchFacts[index]["swap"] == null
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: 16, top: 10, bottom: 10, right: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 110,
                            height: 20,
                            child: Marquee(
                              text: "${matchFacts[index]["nameStr"]} ",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 100.0,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: Duration(seconds: 1),
                              accelerationCurve: Curves.easeIn,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                          matchFacts[index]["type"] == "Card" &&
                                  matchFacts[index]["card"] == "Yellow"
                              ? CachedNetworkImage(
                                  height: 30,
                                  imageUrl:
                                      "https://images.vexels.com/media/users/3/146861/isolated/preview/dcafb4e33c5514e9b53b3d929501feaf-football-yellow-card-icon-by-vexels.png",
                                )
                              : matchFacts[index]["type"] == "Card" &&
                                      matchFacts[index]["card"] == "Red"
                                  ? CachedNetworkImage(
                                      height: 30,
                                      imageUrl:
                                          "https://images.vexels.com/media/users/3/146857/isolated/preview/d55e89657228964a776f7dab3c0537ca-football-red-card-icon-by-vexels.png",
                                    )
                                  : matchFacts[index]["type"] == "Goal"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6.0),
                                          child: CachedNetworkImage(
                                            height: 30,
                                            color: Colors.white,
                                            imageUrl:
                                                "https://static.thenounproject.com/png/542381-200.png",
                                          ),
                                        )
                                      : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              startChild: matchFacts[index]["isHome"] == true &&
                      matchFacts[index]["swap"] == null
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: 16, top: 10, bottom: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          matchFacts[index]["type"] == "Card" &&
                                  matchFacts[index]["card"] == "Yellow"
                              ? CachedNetworkImage(
                                  height: 30,
                                  imageUrl:
                                      "https://images.vexels.com/media/users/3/146861/isolated/preview/dcafb4e33c5514e9b53b3d929501feaf-football-yellow-card-icon-by-vexels.png",
                                )
                              : matchFacts[index]["type"] == "Card" &&
                                      matchFacts[index]["card"] == "Red"
                                  ? CachedNetworkImage(
                                      height: 30,
                                      imageUrl:
                                          "https://images.vexels.com/media/users/3/146857/isolated/preview/d55e89657228964a776f7dab3c0537ca-football-red-card-icon-by-vexels.png",
                                    )
                                  : matchFacts[index]["type"] == "Goal"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: CachedNetworkImage(
                                            height: 30,
                                            color: Colors.white,
                                            imageUrl:
                                                "https://static.thenounproject.com/png/542381-200.png",
                                          ),
                                        )
                                      : SizedBox(),
                          Container(
                            width: 110,
                            height: 20,
                            child: Marquee(
                              text: "${matchFacts[index]["nameStr"]} ",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 0.0,
                              velocity: 50.0,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: Duration(milliseconds: 500),
                              accelerationCurve: Curves.easeIn,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
