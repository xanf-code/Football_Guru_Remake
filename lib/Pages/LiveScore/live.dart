import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/DetailsPage.dart';
import 'package:transfer_news/Utils/constants.dart';

class LiveScoreWidget extends StatefulWidget {
  final int leagueId;
  const LiveScoreWidget({
    Key key,
    this.leagueId,
  }) : super(key: key);

  @override
  _LiveScoreWidgetState createState() => _LiveScoreWidgetState();
}

class _LiveScoreWidgetState extends State<LiveScoreWidget> {
  List LiveScores;

  Map<String, String> headers = {
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'referer': 'https://www.google.com/',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-site',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.100 Safari/537.36',
  };

  Future<String> getLiveScores() async {
    var response = await http.get(
        "https://www.fotmob.com/matches?date=${_selectedValue.toString().replaceAll("-", "").substring(0, 8)}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        LiveScores = jsonresponse["leagues"];
      });
    } else {
      print(response.statusCode);
    }
  }

  bool _loading = false;
  Timer timer;

  @override
  void initState() {
    getLiveScores();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getLiveScores());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  DateTime _selectedValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LiveScores == null
        ? SizedBox.shrink()
        : Column(
            children: [
              FlutterDatePickerTimeline(
                unselectedItemTextStyle: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
                selectedItemTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedItemBackgroundColor: Colors.black,
                initialFocusedDate: DateTime.now(),
                startDate: DateTime(2020, 11, 20),
                endDate: DateTime(2021, 05, 02),
                initialSelectedDate: DateTime.now(),
                onSelectedDateChange: (DateTime dateTime) {
                  setState(
                    () {
                      _loading = true;
                      _selectedValue = dateTime;
                      Future.delayed(
                        Duration(
                          seconds: 5,
                        ),
                      ).whenComplete(() {
                        _loading = false;
                      });
                    },
                  );
                },
              ),
              SizedBox(
                height: 12,
              ),
              _loading == false
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: LiveScores.length,
                      itemBuilder: (context, index) {
                        var scores = LiveScores[index];
                        return scores["primaryId"] == widget.leagueId
                            ? scorecard(context, scores)
                            : SizedBox.shrink();
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12,
                        bottom: 8,
                        // top: 8,
                      ),
                      child: Shimmer.fromColors(
                        highlightColor: Colors.blue,
                        baseColor: Colors.grey[900],
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
            ],
          );
  }

  Container scorecard(BuildContext context, scores) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: LiveScores.length,
        itemBuilder: (context, index) {
          final live = LiveScores[index]["matches"];
          return LiveScores[index]["primaryId"] == widget.leagueId
              ? Row(
                  children: [
                    for (final l in live)
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            pushNewScreen(
                              context,
                              withNavBar: false,
                              customPageRoute: MorpheusPageRoute(
                                builder: (context) => ScoresDetailsWidget(
                                  matchID: l["id"],
                                  homeTeam: l["home"]["name"],
                                  awayTeam: l["away"]["name"],
                                ),
                                transitionDuration: Duration(
                                  milliseconds: 200,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12,
                              bottom: 8,
                              // top: 8,
                            ),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              height: 30,
                                              imageUrl:
                                                  "https://www.fotmob.com/images/league/${scores["primaryId"]}",
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              scores["name"],
                                              style: GoogleFonts.rubik(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        l["status"]["started"] == true &&
                                                l["status"]["ongoing"] == true
                                            ? Text(
                                                l["status"]["liveTime"]["short"]
                                                    .toString(),
                                                style: GoogleFonts.rubik(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : l["status"]["started"] == true &&
                                                    l["status"]["finished"] ==
                                                        true
                                                ? Text(
                                                    l["status"]["reason"]
                                                        ["long"],
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    Jiffy("${l["time"].replaceAll(".", "-")}",
                                                            "dd-MM-yyyy")
                                                        .format("EEEE"),
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  width: 1,
                                                  color: tagBorder,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://www.fotmob.com/images/team/${l["home"]["id"]}_small",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              l["home"]["name"].toString(),
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          children: [
                                            l["status"]["started"] == false &&
                                                    l["status"]["finished"] ==
                                                        false &&
                                                    l["status"]["finished"] ==
                                                        false
                                                ? Text(
                                                    "0 : 0",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 40,
                                                    ),
                                                  )
                                                : l["status"]["started"] ==
                                                            true &&
                                                        l["status"]
                                                                ["ongoing"] ==
                                                            true
                                                    ? Shimmer.fromColors(
                                                        baseColor: Colors.white,
                                                        highlightColor:
                                                            pollColor,
                                                        child: Text(
                                                          l["status"]
                                                                  ["scoreStr"]
                                                              .toString()
                                                              .replaceAll(
                                                                  "-", ":"),
                                                          style:
                                                              GoogleFonts.rubik(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 40,
                                                          ),
                                                        ),
                                                      )
                                                    : l["status"]["started"] ==
                                                                true &&
                                                            l["status"][
                                                                    "finished"] ==
                                                                true
                                                        ? Text(
                                                            l["status"]
                                                                    ["scoreStr"]
                                                                .toString()
                                                                .replaceAll(
                                                                    "-", ":"),
                                                            style: GoogleFonts
                                                                .rubik(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 40,
                                                            ),
                                                          )
                                                        : Text(""),
                                            l["status"]["aggregatedStr"] != null
                                                ? Text(
                                                    "Aggregate: ( ${l["status"]["aggregatedStr"]} )",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  width: 1,
                                                  color: tagBorder,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://www.fotmob.com/images/team/${l["away"]["id"]}_small",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              l["away"]["name"].toString(),
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : SizedBox();
        },
      ),
    );
  }
}
