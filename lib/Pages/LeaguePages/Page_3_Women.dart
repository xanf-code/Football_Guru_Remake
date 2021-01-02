import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/AFCAsianCup2022Callback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/IWLCallBack.dart';
import 'package:transfer_news/Widgets/WomensHomeCard.dart';

class WomensPage extends StatefulWidget {
  @override
  _WomensPageState createState() => _WomensPageState();
}

class _WomensPageState extends State<WomensPage>
    with AutomaticKeepAliveClientMixin<WomensPage> {
  String url = "https://www.the-aiff.com/api/national-team-fixtures/2/30";
  String IWLurl = "https://www.the-aiff.com/api/competition/fixtures/11";

  List seniorFixture;
  List IWLFixtures;
  List GoldCup;

  Future<String> getFixtures() async {
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        seniorFixture = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getIWLFixtures() async {
    var response = await http.get(
      IWLurl,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        IWLFixtures = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getGoldCup() async {
    var response = await http.get(
      "https://www.the-aiff.com/api/competition/fixtures/20",
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        GoldCup = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getFixtures();
    getIWLFixtures();
    getGoldCup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IWLFixtures == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => AsianCup2022(),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: seniorFixture == null || seniorFixture.isEmpty
                    ? SizedBox()
                    : WomensHomeCard(
                        leagueLogo:
                            "https://upload.wikimedia.org/wikipedia/en/thumb/6/68/AFC_Women%27s_Asian_Cup.png/220px-AFC_Women%27s_Asian_Cup.png",
                        leagueName: seniorFixture[0]["tournament_name"],
                        leagueYear: seniorFixture[0]["match_date"],
                        evenName: seniorFixture[0]["tournament_name"],
                        eventVenue: seniorFixture[0]["venue"],
                        team1Logo: seniorFixture[0]["team1_logo"],
                        team1Name: seniorFixture[0]["team1_name"],
                        team1Score: seniorFixture[0]["team1_score"] == null
                            ? "-"
                            : seniorFixture[0]["team1_score"].toString(),
                        team2Logo: seniorFixture[0]["team2_logo"],
                        team2Name: seniorFixture[0]["team2_name"],
                        team2Score: seniorFixture[0]["team2_score"] == null
                            ? "-"
                            : seniorFixture[0]["team2_score"].toString(),
                      ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => IWLCallback(),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: IWLFixtures == null || IWLFixtures.isEmpty
                    ? SizedBox()
                    : WomensHomeCard(
                        leagueLogo: IWLFixtures[0]["tournament_logo"],
                        leagueName: IWLFixtures[0]["tournament_name"],
                        leagueYear: IWLFixtures[0]["match_date"],
                        evenName: IWLFixtures[0]["tournament_name"],
                        eventVenue: IWLFixtures[0]["venue"],
                        team1Logo: IWLFixtures[0]["team1_logo"],
                        team1Name: IWLFixtures[0]["team1_name"],
                        team1Score: IWLFixtures[0]["team1_score"] == null
                            ? "-"
                            : IWLFixtures[0]["team1_score"].toString(),
                        team2Logo: IWLFixtures[0]["team2_logo"],
                        team2Name: IWLFixtures[0]["team2_name"],
                        team2Score: IWLFixtures[0]["team2_score"] == null
                            ? "-"
                            : IWLFixtures[0]["team2_score"].toString(),
                      ),
              ),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
