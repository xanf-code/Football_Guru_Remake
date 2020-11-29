import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/DetailsPage.dart';

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
  String urlPath = "https://www.fotmob.com/matches/";
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
    var response = await http.get(urlPath, headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        LiveScores = jsonresponse["leagues"];
      });
    } else {
      print(response.statusCode);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return LiveScores == null
        ? SizedBox()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: LiveScores.length,
            itemBuilder: (context, index) {
              var scores = LiveScores[index];
              final live = LiveScores[index]["matches"];
              return scores["primaryId"] == widget.leagueId
                  ? GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => ScoresDetailsWidget(
                              matchID: scores["matches"][0]["id"],
                              homeTeam: scores["matches"][0]["home"]["name"],
                              awayTeam: scores["matches"][0]["away"]["name"],
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    scores["matches"][0]["status"]["started"] ==
                                                true &&
                                            scores["matches"][0]["status"]
                                                    ["ongoing"] ==
                                                true
                                        ? Text(
                                            scores["matches"][0]["status"]
                                                    ["liveTime"]["short"]
                                                .toString(),
                                            style: GoogleFonts.rubik(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          )
                                        : scores["matches"][0]["status"]
                                                        ["started"] ==
                                                    true &&
                                                scores["matches"][0]["status"]
                                                        ["finished"] ==
                                                    true
                                            ? Text(
                                                scores["matches"][0]["status"]
                                                    ["reason"]["long"],
                                                style: GoogleFonts.rubik(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                Jiffy("${scores["matches"][0]["time"].replaceAll(".", "-")}",
                                                        "dd-MM-yyyy")
                                                    .format("EEEE"),
                                                style: GoogleFonts.rubik(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              color: Color(0xFF7232f2),
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
                                                    "https://www.fotmob.com/images/team/${scores["matches"][0]["home"]["id"]}_small",
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          scores["matches"][0]["home"]["name"]
                                              .toString(),
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
                                        scores["matches"][0]["status"]["started"] == false &&
                                                scores["matches"][0]["status"]
                                                        ["finished"] ==
                                                    false &&
                                                scores["matches"][0]["status"]
                                                        ["finished"] ==
                                                    false
                                            ? Text(
                                                "0 : 0",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 40,
                                                ),
                                              )
                                            : scores["matches"][0]["status"]
                                                            ["started"] ==
                                                        true &&
                                                    scores["matches"][0]["status"]
                                                            ["ongoing"] ==
                                                        true
                                                ? Shimmer.fromColors(
                                                    baseColor: Colors.white,
                                                    highlightColor:
                                                        Colors.blueAccent,
                                                    child: Text(
                                                      scores["matches"][0]
                                                                  ["status"]
                                                              ["scoreStr"]
                                                          .toString()
                                                          .replaceAll("-", ":"),
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  )
                                                : scores["matches"][0]["status"]
                                                                ["started"] ==
                                                            true &&
                                                        scores["matches"][0]
                                                                    ["status"]
                                                                ["finished"] ==
                                                            true
                                                    ? Text(
                                                        scores["matches"][0]
                                                                    ["status"]
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
                                                      )
                                                    : Text(""),
                                        scores["matches"][0]["status"]
                                                    ["aggregatedStr"] !=
                                                null
                                            ? Text(
                                                "Aggregate: ( ${scores["matches"][0]["status"]["aggregatedStr"]} )",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w500,
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
                                              color: Color(0xFF7232f2),
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
                                                    "https://www.fotmob.com/images/team/${scores["matches"][0]["away"]["id"]}_small",
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          scores["matches"][0]["away"]["name"]
                                              .toString(),
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
                    )
                  : SizedBox();
            },
          );
  }
}
