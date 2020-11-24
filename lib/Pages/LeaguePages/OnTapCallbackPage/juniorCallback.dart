import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Pages/Standings/junior.dart';
import 'package:transfer_news/Widgets/StatsWidget.dart';
import 'dart:convert';

import 'package:transfer_news/Widgets/fixturecard.dart';

class JuniorCallBackPage extends StatefulWidget {
  final url;

  const JuniorCallBackPage({Key key, this.url}) : super(key: key);
  @override
  _JuniorCallBackPageState createState() => _JuniorCallBackPageState();
}

class _JuniorCallBackPageState extends State<JuniorCallBackPage> {
  List allFixtures;

  Future<String> getAllFixtures() async {
    var response = await http.get(
      "https://www.the-aiff.com/api/competition/fixtures/${widget.url}",
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
                    text: "Stats",
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
                        date: allFixtures[index]["date"],
                        month: allFixtures[index]["month"],
                        day: allFixtures[index]["day"],
                        eventVenue: allFixtures[index]["venue"],
                        team1Logo: allFixtures[index]["team1_logo"],
                        team1Name: allFixtures[index]["team1_name"],
                        team1Score:
                            allFixtures[index]["team1_score"].toString(),
                        team2Logo: allFixtures[index]["team2_logo"],
                        team2Name: allFixtures[index]["team2_name"],
                        team2Score:
                            allFixtures[index]["team2_score"].toString(),
                      );
                    },
                  ),
            JuniorStandings(),
            StatsWidget(
              url: "https://www.the-aiff.com/api/competition/stats/4",
            ),
          ],
        ),
      ),
    );
  }
}
