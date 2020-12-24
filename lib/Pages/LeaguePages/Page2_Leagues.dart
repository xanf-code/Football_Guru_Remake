import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/ILeagueCallBackPage.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/ISLCallback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/div2Callback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/eliteCallback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/juniorCallback.dart';
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/subjuniorCallback.dart';
import 'dart:convert';

import 'package:transfer_news/Widgets/LeagueCard.dart';

class LeaguePage extends StatefulWidget {
  @override
  _LeaguePageState createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage>
    with AutomaticKeepAliveClientMixin<LeaguePage> {
  String urlPathISL =
      "https://www.fotmob.com/leagues?id=9478&tab=overview&type=league&timeZone=Asia%2FCalcutta&seo=super-league";
  String urlPathIleague =
      "https://www.fotmob.com/leagues?id=8982&tab=overview&type=league&timeZone=Asia%2FCalcutta&seo=super-league";
  String url2nd = "https://www.the-aiff.com/api/competition/fixtures/6";
  String urlelite = "https://www.the-aiff.com/api/competition/fixtures/3";
  String urljun = "https://www.the-aiff.com/api/competition/fixtures/4";
  String urlsubjun = "https://www.the-aiff.com/api/competition/fixtures/5";

  List islFixtures = [];
  List ileagueFixtures = [];
  List ileague2ndFixtures = [];
  List eliteLeague = [];
  List juniorLeague = [];
  List subJuniorLeague = [];

  Future<String> getISLFixtures() async {
    var response = await http.get(
      urlPathISL,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        islFixtures = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getIleagueFixtures() async {
    var response = await http.get(
      urlPathIleague,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        ileagueFixtures = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> get2ndDivision() async {
    var response = await http.get(
      url2nd,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        ileague2ndFixtures = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getEliteLeague() async {
    var response = await http.get(
      urlelite,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        eliteLeague = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getJunior() async {
    var response = await http.get(
      urljun,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        juniorLeague = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getsubJunior() async {
    var response = await http.get(
      urlsubjun,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        subJuniorLeague = jsonresponse["fixtures"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getISLFixtures();
    getIleagueFixtures();
    get2ndDivision();
    getEliteLeague();
    getJunior();
    getsubJunior();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => ISLCallBack(),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: islFixtures == null || islFixtures.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://upload.wikimedia.org/wikipedia/en/thumb/b/b0/Indian_Super_League_logo.svg/1200px-Indian_Super_League_logo.svg.png",
                  leagueName: "Indian Super League",
                  leagueYear: "Season 2020/21",
                  evenName: "Indian Super League",
                  eventVenue: islFixtures[0]["status"]["startDateStr"],
                  team1Logo:
                      "https://www.fotmob.com/images/team/${islFixtures[0]["home"]["id"]}_small",
                  team1Name: islFixtures[0]["home"]["name"],
                  team1Score: islFixtures[0]["home"]["score"] == null
                      ? "-"
                      : islFixtures[0]["home"]["score"].toString(),
                  team2Logo:
                      "https://www.fotmob.com/images/team/${islFixtures[0]["away"]["id"]}_small",
                  team2Name: islFixtures[0]["away"]["name"],
                  team2Score: islFixtures[0]["away"]["score"] == null
                      ? "-"
                      : islFixtures[0]["away"]["score"].toString(),
                ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => ILeagueCallBackPage(),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: ileagueFixtures == null || ileagueFixtures.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://upload.wikimedia.org/wikipedia/en/thumb/7/72/I-League_logo.svg/1200px-I-League_logo.svg.png",
                  leagueName: "Hero I-League",
                  leagueYear: "Season 2019/20",
                  evenName: "Hero I-League",
                  eventVenue: ileagueFixtures[0]["status"]["startDateStr"],
                  team1Logo:
                      "https://www.fotmob.com/images/team/${ileagueFixtures[0]["home"]["id"]}_small",
                  team1Name: ileagueFixtures[0]["home"]["name"],
                  team1Score:
                      ileagueFixtures[0]["home"]["score"].toString() == "null"
                          ? "-"
                          : ileagueFixtures[0]["home"]["score"].toString(),
                  team2Logo:
                      "https://www.fotmob.com/images/team/${ileagueFixtures[0]["away"]["id"]}_small",
                  team2Name: ileagueFixtures[0]["away"]["name"],
                  team2Score:
                      ileagueFixtures[0]["away"]["score"].toString() == "null"
                          ? "-"
                          : ileagueFixtures[0]["away"]["score"].toString(),
                ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => Div2CallBackPage(
                  url: 6,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: ileague2ndFixtures == null || ileague2ndFixtures.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://upload.wikimedia.org/wikipedia/en/4/47/I-League_2nd_Division_Logo_2015.png",
                  leagueName: "I-League 2nd Division",
                  leagueYear: "Season 2019/20",
                  evenName: ileague2ndFixtures[0]["tournament_name"],
                  eventVenue: ileague2ndFixtures[0]["venue"],
                  team1Logo: ileague2ndFixtures[0]["team1_logo"],
                  team1Name: ileague2ndFixtures[0]["team1_name"],
                  team1Score: ileague2ndFixtures[0]["team1_score"].toString(),
                  team2Logo: ileague2ndFixtures[0]["team2_logo"],
                  team2Name: ileague2ndFixtures[0]["team2_name"],
                  team2Score: ileague2ndFixtures[0]["team2_score"].toString(),
                ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => eliteCallBackPage(
                  url: 3,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: eliteLeague == null || eliteLeague.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://upload.wikimedia.org/wikipedia/en/b/ba/Youth_League_U18_logo.png",
                  leagueName: "Hero Elite League",
                  leagueYear: "Season 2019/20",
                  evenName: eliteLeague[0]["tournament_name"],
                  eventVenue: eliteLeague[0]["venue"],
                  team1Logo: eliteLeague[0]["team1_logo"],
                  team1Name: eliteLeague[0]["team1_name"],
                  team1Score: eliteLeague[0]["team1_score"].toString(),
                  team2Logo: eliteLeague[0]["team2_logo"],
                  team2Name: eliteLeague[0]["team2_name"],
                  team2Score: eliteLeague[0]["team2_score"].toString(),
                ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => JuniorCallBackPage(
                  url: 4,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: juniorLeague == null || juniorLeague.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://www.the-aiff.com/assets/images/testimg.png",
                  leagueName: "Hero Junior League",
                  leagueYear: "Season 2019/20",
                  evenName: juniorLeague[0]["tournament_name"],
                  eventVenue: juniorLeague[0]["venue"],
                  team1Logo: juniorLeague[0]["team1_logo"],
                  team1Name: juniorLeague[0]["team1_name"],
                  team1Score: juniorLeague[0]["team1_score"].toString(),
                  team2Logo: juniorLeague[0]["team2_logo"],
                  team2Name: juniorLeague[0]["team2_name"],
                  team2Score: juniorLeague[0]["team2_score"].toString(),
                ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => subJuniorCallBackPage(
                  url: 5,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
          child: subJuniorLeague == null || subJuniorLeague.isEmpty
              ? const SizedBox.shrink()
              : LeagueCard(
                  leagueLogo:
                      "https://www.the-aiff.com/assets/images/testimg.png",
                  leagueName: "Hero Sub-Junior League",
                  leagueYear: "Season 2019/20",
                  evenName: subJuniorLeague[0]["tournament_name"],
                  eventVenue: subJuniorLeague[0]["venue"],
                  team1Logo: subJuniorLeague[0]["team1_logo"],
                  team1Name: subJuniorLeague[0]["team1_name"],
                  team1Score: subJuniorLeague[0]["team1_score"].toString(),
                  team2Logo: subJuniorLeague[0]["team2_logo"],
                  team2Name: subJuniorLeague[0]["team2_name"],
                  team2Score: subJuniorLeague[0]["team2_score"].toString(),
                ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
