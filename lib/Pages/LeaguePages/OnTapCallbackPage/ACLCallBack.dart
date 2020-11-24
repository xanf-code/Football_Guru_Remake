import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Pages/LeaguePages/News/NewsCardAFCACL.dart';
import 'package:transfer_news/Pages/Standings/ACLStandings.dart';
import 'package:transfer_news/Pages/Standings/AFCCupStandings.dart';
import 'dart:convert';

import 'package:transfer_news/Widgets/fixturecard.dart';

class ACLCallBack extends StatefulWidget {
  @override
  _ACLCallBackState createState() => _ACLCallBackState();
}

class _ACLCallBackState extends State<ACLCallBack>
    with AutomaticKeepAliveClientMixin<ACLCallBack> {
  List allFixtures;

  Future<String> getAllFixtures() async {
    var response = await http.get(
      "https://www.fotmob.com/leagues?id=525&tab=fixtures&type=league&timeZone=Asia%2FCalcutta&seo=afc-cup",
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        allFixtures = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAllFixtures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                isScrollable: true,
                indicator: DotIndicator(
                  color: Colors.white,
                  distanceFromCenter: 16,
                  radius: 3,
                  paintingStyle: PaintingStyle.fill,
                ),
                tabs: <Widget>[
                  Tab(
                    text: "Fixtures",
                  ),
                  Tab(
                    text: "Standings",
                  ),
                  Tab(
                    text: "News",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            allFixtures == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: allFixtures.length,
                    itemBuilder: (context, index) {
                      return FixtureCard(
                        date: allFixtures[index]["status"]["startDateStr"],
                        month: "",
                        day: "",
                        eventVenue: allFixtures[index]["status"]["reason"] ==
                                null
                            ? "TBP"
                            : allFixtures[index]["status"]["reason"]["long"],
                        team1Logo:
                            "https://www.fotmob.com/images/team/${allFixtures[index]["home"]["id"]}_small",
                        team1Name: allFixtures[index]["home"]["name"],
                        team1Score: allFixtures[index]["home"]["score"] == null
                            ? "-"
                            : allFixtures[index]["home"]["score"].toString(),
                        team2Logo:
                            "https://www.fotmob.com/images/team/${allFixtures[index]["away"]["id"]}_small",
                        team2Name: allFixtures[index]["away"]["name"],
                        team2Score: allFixtures[index]["away"]["score"] == null
                            ? "-"
                            : allFixtures[index]["away"]["score"].toString(),
                      );
                    },
                  ),
            ACLStandings(),
            NewsCardWidget(
              url:
                  "https://www.fotmob.com/searchData?term=afc+champions+league&timeZone=Asia%2FCalcutta&fetchMore=news",
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
