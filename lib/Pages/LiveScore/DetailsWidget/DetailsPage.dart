import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/H2H/headtohead.dart';
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/LiveTicker/ticker.dart';
import 'package:transfer_news/Pages/LiveScore/DetailsWidget/Widgets/timeline.dart';
import 'package:transfer_news/Pages/LiveScore/LiveStats/statsPage.dart';
import 'package:transfer_news/Pages/LiveScore/lineups.dart';
import 'Widgets/BenchLineUpWidget.dart';
import 'Widgets/CoachLineUpWidget.dart';

class ScoresDetailsWidget extends StatefulWidget {
  final int matchID;
  final String homeTeam;
  final String awayTeam;
  ScoresDetailsWidget({Key key, this.matchID, this.homeTeam, this.awayTeam})
      : super(key: key);
  @override
  _ScoresDetailsWidgetState createState() => _ScoresDetailsWidgetState();
}

class _ScoresDetailsWidgetState extends State<ScoresDetailsWidget> {
  List liveHeaderDetails;
  List team1formation;
  List team2formation;
  List matchFacts;

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

  Future<String> headerDetails() async {
    var response = await http.get(
        "https://www.fotmob.com/matchDetails?matchId=${widget.matchID}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        liveHeaderDetails = jsonresponse["header"]["teams"];
        team1formation = jsonresponse["content"]["lineup"]["lineup"];
        team2formation = jsonresponse["content"]["lineup"]["lineup"];
        matchFacts = jsonresponse["content"]["matchFacts"]["events"]["events"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    headerDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return liveHeaderDetails == null
        ? Material(
            color: Color(0xFF0e0e10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(
                    height: 14,
                  ),
                  DelayedDisplay(
                    delay: Duration(
                      seconds: 8,
                    ),
                    child: Text(
                      "Lineups not yet announced",
                      style: GoogleFonts.rubik(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        : DefaultTabController(
            length: 5,
            child: Scaffold(
              backgroundColor: Color(0xFF0e0e10),
              appBar: AppBar(
                backgroundColor: Color(0xFF0e0e10),
                title: Text("${widget.homeTeam} vs ${widget.awayTeam}"),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(280),
                  child: Column(
                    children: [
                      liveHeaderDetails != null
                          ? ListView(
                              shrinkWrap: true,
                              children: [
                                Header(),
                              ],
                            )
                          : Center(child: CircularProgressIndicator()),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: TabBar(
                          labelStyle: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[900],
                          ),
                          tabs: <Widget>[
                            Tab(
                              text: "Lineups",
                            ),
                            Tab(
                              text: "Match Facts",
                            ),
                            Tab(
                              text: "Live Ticker",
                            ),
                            Tab(
                              text: "Stats",
                            ),
                            Tab(
                              text: "H2H",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  LineupBody(liveHeaderDetails[0]["name"],
                      liveHeaderDetails[1]["name"]),
                  TimeLineWidget(matchFacts: matchFacts),
                  LiveTicker(
                    matchID: widget.matchID,
                  ),
                  LiveStats(
                    matchID: widget.matchID,
                  ),
                  HeadToHead(
                    matchId: widget.matchID,
                  )
                ],
              ),
            ),
          );
  }

  ListView Header() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        height: 100,
                        imageUrl:
                            "https://www.fotmob.com/${liveHeaderDetails[0]["imageUrl"]}",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: Text(
                    "${liveHeaderDetails[0]["score"].toString()} : ${liveHeaderDetails[1]["score"].toString()}",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                          height: 100,
                          imageUrl:
                              "https://www.fotmob.com/${liveHeaderDetails[1]["imageUrl"]}"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LineupBody(String home, String away) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: TabBar(
              tabs: [
                Tab(
                  text: home,
                ),
                Tab(
                  text: away,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            team1(),
            team2(),
          ],
        ),
      ),
    );
  }

  ListView team2() {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        team2formation == null
            ? const SizedBox()
            : Container(
                color: Colors.grey[900],
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Text(
                        "Formation",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20,
          ),
          child: Center(
            child: Text(
              team1formation[1]["lineup"],
              style: GoogleFonts.rubik(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Coach",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        CoachesLineUp(
          matchID: widget.matchID,
          teamIndex: 1,
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Players",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Linups(
          matchID: widget.matchID,
          listIndex: 1,
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Bench",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        BenchPlayers(
          teamIndex: 1,
          matchID: widget.matchID,
          Mainindex: 1,
        )
      ],
    );
  }

  ListView team1() {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        team1formation == null
            ? const SizedBox()
            : Container(
                color: Colors.grey[900],
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Text(
                        "Formation",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20,
          ),
          child: Center(
            child: Text(
              team1formation[0]["lineup"],
              style: GoogleFonts.rubik(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Coach",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        CoachesLineUp(
          matchID: widget.matchID,
          teamIndex: 0,
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Players",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Linups(
          matchID: widget.matchID,
          listIndex: 0,
        ),
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  "Bench",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        BenchPlayers(
          teamIndex: 0,
          matchID: widget.matchID,
          Mainindex: 0,
        )
      ],
    );
  }
}
