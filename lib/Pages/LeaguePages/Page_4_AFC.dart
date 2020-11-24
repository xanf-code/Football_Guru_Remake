import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/ACLCallBack.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/AFCAsianCup2022Callback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/AFCCallBack.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/IWLCallBack.dart';
import 'package:transfer_news/Widgets/LeagueCard.dart';
import 'package:transfer_news/Widgets/WomensHomeCard.dart';

class ContinentalTournaments extends StatefulWidget {
  @override
  _ContinentalTournamentsState createState() => _ContinentalTournamentsState();
}

class _ContinentalTournamentsState extends State<ContinentalTournaments>
    with AutomaticKeepAliveClientMixin<ContinentalTournaments> {
  String afcUrl =
      "https://www.fotmob.com/leagues?id=9469&tab=overview&type=league&timeZone=Asia%2FCalcutta&seo=afc-cup";
  String aclUrl =
      "https://www.fotmob.com/leagues?id=525&tab=overview&type=league&timeZone=Asia%2FCalcutta&seo=afc-cup";

  List afcFixList;
  List aclFixList;

  Future<String> getAFCFixtures() async {
    var response = await http.get(
      afcUrl,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        afcFixList = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getACLFixtures() async {
    var response = await http.get(
      aclUrl,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        aclFixList = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAFCFixtures();
    getACLFixtures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return aclFixList == null
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
                      builder: (context) => AFCCallBack(),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: afcFixList == null
                    ? SizedBox()
                    : LeagueCard(
                        leagueLogo:
                            "https://upload.wikimedia.org/wikipedia/en/thumb/2/2d/AFC_Cup_logo.svg/1200px-AFC_Cup_logo.svg.png",
                        leagueName: "AFC Cup",
                        leagueYear: "Season 2019/20",
                        evenName: "AFC Cup 2019/20",
                        eventVenue: afcFixList[0]["status"]["startDateStr"],
                        team1Logo:
                            "https://www.fotmob.com/images/team/${afcFixList[0]["home"]["id"]}_small",
                        team1Name: afcFixList[0]["home"]["name"],
                        team1Score: afcFixList[0]["home"]["score"].toString(),
                        team2Logo:
                            "https://www.fotmob.com/images/team/${afcFixList[0]["away"]["id"]}_small",
                        team2Name: afcFixList[0]["away"]["name"],
                        team2Score: afcFixList[0]["away"]["score"].toString(),
                      ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => ACLCallBack(),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: aclFixList == null
                    ? SizedBox()
                    : LeagueCard(
                        leagueLogo:
                            "https://upload.wikimedia.org/wikipedia/en/0/0b/AFC_Champions_League_2008_logo.png",
                        leagueName: "AFC Champions League",
                        leagueYear: "Season 2019/20",
                        evenName: "AFC Champions League (ACL)",
                        eventVenue: aclFixList[0]["status"]["startDateStr"],
                        team1Logo:
                            "https://www.fotmob.com/images/team/${aclFixList[0]["home"]["id"]}_small",
                        team1Name: aclFixList[0]["home"]["name"],
                        team1Score: aclFixList[0]["home"]["score"].toString(),
                        team2Logo:
                            "https://www.fotmob.com/images/team/${aclFixList[0]["away"]["id"]}_small",
                        team2Name: aclFixList[0]["away"]["name"],
                        team2Score: aclFixList[0]["away"]["score"].toString(),
                      ),
              ),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
