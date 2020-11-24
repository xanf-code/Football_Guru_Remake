import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Pages/WomenSquad/WomenNTSquad.dart';
import 'dart:convert';

import 'package:transfer_news/Widgets/fixturecard.dart';

class AsianCup2022 extends StatefulWidget {
  @override
  _AsianCup2022State createState() => _AsianCup2022State();
}

class _AsianCup2022State extends State<AsianCup2022>
    with AutomaticKeepAliveClientMixin<AsianCup2022> {
  String url = "https://www.the-aiff.com/api/national-team-fixtures/2/30";

  List seniorAllFixture;

  Future<String> getFixtures() async {
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        seniorAllFixture = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getFixtures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    text: "Squad",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            seniorAllFixture == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: seniorAllFixture.length,
                    itemBuilder: (context, index) {
                      return FixtureCard(
                        date: seniorAllFixture[index]["date"],
                        month: seniorAllFixture[index]["month"],
                        day: seniorAllFixture[index]["day"],
                        eventVenue: seniorAllFixture[index]["venue"],
                        team1Logo: seniorAllFixture[index]["team1_logo"],
                        team1Name: seniorAllFixture[index]["team1_name"],
                        team1Score: seniorAllFixture[index]["team1_score"] ==
                                null
                            ? "-"
                            : seniorAllFixture[index]["team1_score"].toString(),
                        team2Logo: seniorAllFixture[index]["team2_logo"],
                        team2Name: seniorAllFixture[index]["team2_name"],
                        team2Score: seniorAllFixture[index]["team2_score"] ==
                                null
                            ? "-"
                            : seniorAllFixture[index]["team2_score"].toString(),
                      );
                    },
                  ),
            WomenNTSquad(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
