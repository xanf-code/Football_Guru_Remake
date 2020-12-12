import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Helper/NationalTeamFixture_helper.dart';
import 'package:transfer_news/Model/IndianTeamFixtures.dart';
import 'package:transfer_news/Widgets/InternationalLeagueCard.dart';
import 'package:transfer_news/Widgets/rankingcards.dart';
import 'package:transfer_news/Widgets/squadWidget.dart';

class NationalTeam extends StatefulWidget {
  @override
  _NationalTeamState createState() => _NationalTeamState();
}

class _NationalTeamState extends State<NationalTeam>
    with AutomaticKeepAliveClientMixin<NationalTeam> {
  String urlPath = "https://api.sofascore.com/api/v1/rankings/type/2";
  List worldRankings;
  List<IndiaFixturesModel> fixtures = new List<IndiaFixturesModel>();

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

  Future<String> getWorldRankings() async {
    var response = await http.get(urlPath, headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        worldRankings = jsonresponse["rankings"];
      });
    } else {
      print(response.statusCode);
    }
  }

  getFixtures() async {
    FixturesList fixturesListClass = FixturesList();
    await fixturesListClass.getLatestFixture();
    fixtures = fixturesListClass.allFixtures;
  }

  @override
  void initState() {
    getFixtures();
    getWorldRankings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return worldRankings == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Color(0xFF0e0e10),
            body: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: worldRankings.length,
                  itemBuilder: (context, index) {
                    return worldRankings[index]["team"]["name"] == "India"
                        ? IndiaRanking(context, index)
                        : const SizedBox();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: fixtures.length,
                  itemBuilder: (context, index) {
                    return IntLeagueCard(
                      leagueLogo: fixtures[index].tournamentId == 10416
                          ? "https://freepngimg.com/thumb/trophy/75846-trophy-cup-icon-free-download-image.png"
                          : "https://api.sofascore.com/api/v1/unique-tournament/${fixtures[index].tournamentId}/image",
                      leagueName: fixtures[index].tournamentName,
                      leagueYear: fixtures[index].eventStatus,
                      evenName: fixtures[index].tournamentName,
                      eventVenue: DateFormat.yMMMd()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              fixtures[index].datetime * 1000))
                          .toString(),
                      team1Logo:
                          "https://www.sofascore.com/images/team-logo/football_${fixtures[index].homeTeamID}.png",
                      team1Name: fixtures[index].homeTeamName,
                      team1Score: fixtures[index].eventStatus == "postponed"
                          ? "-"
                          : fixtures[index].homeTeamScore.toString(),
                      team2Logo:
                          "https://www.sofascore.com/images/team-logo/football_${fixtures[index].awayTeamID}.png",
                      team2Name: fixtures[index].awayTeamName,
                      team2Score: fixtures[index].eventStatus == "postponed"
                          ? "-"
                          : fixtures[index].awayTeamScore.toString(),
                    );
                  },
                )
              ],
            ),
          );
  }

  IndiaRanking(BuildContext context, int index) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF0d2758),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    height: 100,
                    imageUrl:
                        "https://www.sofascore.com/images/team-logo/football_${worldRankings[index]["team"]["id"]}.png",
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${worldRankings[index]["team"]["name"]}n Football Team",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Ionicons.md_podium,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            worldRankings[index]["team"]["ranking"].toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RankingCards(
              type: "Current FIFA Ranking :",
              rank: worldRankings[index]["team"]["ranking"].toString(),
              iconType: Ionicons.md_arrow_up,
            ),
            RankingCards(
              type: "FIFA Points :",
              rank: worldRankings[index]["points"].toString(),
              iconType: Ionicons.md_arrow_up,
            ),
            RankingCards(
              type: "Previous FIFA Ranking :",
              rank: worldRankings[index]["previousRanking"].toString(),
              iconType: Ionicons.md_arrow_down,
            ),
            RankingCards(
              type: "Previous FIFA Ranking :",
              rank: worldRankings[index]["previousPoints"].toString(),
              iconType: Ionicons.md_arrow_down,
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF0e0e10),
                      content: Container(
                        width: double.maxFinite,
                        child: SquadWidget(),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 30,
                height: 30,
                child: Icon(
                  AntDesign.team,
                  color: Colors.black,
                  size: 18,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFe0f2f1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
