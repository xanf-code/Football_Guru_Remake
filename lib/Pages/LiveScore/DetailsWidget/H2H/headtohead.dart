import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/H2HFixtureCard.dart';
import 'dart:convert';

class HeadToHead extends StatefulWidget {
  final int matchId;

  const HeadToHead({Key key, this.matchId}) : super(key: key);
  @override
  _HeadToHeadState createState() => _HeadToHeadState();
}

class _HeadToHeadState extends State<HeadToHead>
    with AutomaticKeepAliveClientMixin<HeadToHead> {
  List headtohead;
  List h2hStats;
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

  Future<String> H2H() async {
    var response = await http.get(
        "https://www.fotmob.com/matchDetails?matchId=${widget.matchId}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        headtohead = jsonresponse["content"]["h2h"]["matches"];
        h2hStats = jsonresponse["content"]["h2h"]["summary"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    H2H();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return headtohead == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Wins",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF7232f2),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                h2hStats
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .substring(0, 1),
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Draws",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF7232f2),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                h2hStats
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .substring(3, 4),
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Wins",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF7232f2),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                h2hStats
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .substring(6, 7),
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: headtohead.length,
                itemBuilder: (context, index) {
                  return H2HFixtureCard(
                    eventVenue: headtohead[index]["league"]["name"],
                    date: headtohead[index]["time"],
                    team1Name: headtohead[index]["home"]["name"],
                    team1Logo: headtohead[index]["home"]["id"],
                    team1Score: headtohead[index]["status"]["scoreStr"] == null
                        ? "-"
                        : headtohead[index]["status"]["scoreStr"]
                            .toString()
                            .substring(0, 1),
                    team2Score: headtohead[index]["status"]["scoreStr"] == null
                        ? "-"
                        : headtohead[index]["status"]["scoreStr"]
                            .substring(4, 5),
                    team2Name: headtohead[index]["away"]["name"],
                    team2Logo: headtohead[index]["away"]["id"],
                  );
                },
              ),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
