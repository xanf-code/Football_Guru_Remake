import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:transfer_news/Model/IndianTeamFixtures.dart';
import 'dart:convert' as convert;

import 'package:transfer_news/Model/tmnewsmodel.dart';

class FixturesList {
  List<IndiaFixturesModel> allFixtures = [];

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

  Future<void> getLatestFixture() async {
    String url = "https://api.sofascore.com/api/v1/team/4828/events/last/0";
    var response = await http.get(url, headers: headers);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      jsonData["events"].forEach(
        (element) {
          IndiaFixturesModel indiaFixturesModel = IndiaFixturesModel(
            tournamentName: element["tournament"]["name"],
            eventStatus: element["status"]["type"],
            tournamentId: element["tournament"]["uniqueTournament"]["id"],
            homeTeamName: element["homeTeam"]["name"],
            homeTeamID: element["homeTeam"]["id"],
            homeTeamScore: element["homeScore"]["current"],
            awayTeamName: element["awayTeam"]["name"],
            awayTeamID: element["awayTeam"]["id"],
            awayTeamScore: element["awayScore"]["current"],
            datetime: element["startTimestamp"],
          );
          allFixtures.add(indiaFixturesModel);
        },
      );
    }
  }
}
