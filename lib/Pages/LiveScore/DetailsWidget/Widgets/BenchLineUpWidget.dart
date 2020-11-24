import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LiveScore/IndividualStats/individual.dart';

class BenchPlayers extends StatefulWidget {
  final int teamIndex;
  final int matchID;
  final int Mainindex;

  const BenchPlayers({Key key, this.teamIndex, this.matchID, this.Mainindex})
      : super(key: key);
  @override
  _BenchPlayersState createState() => _BenchPlayersState();
}

class _BenchPlayersState extends State<BenchPlayers>
    with AutomaticKeepAliveClientMixin<BenchPlayers> {
  List benchLineUp;

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

  Future<String> getBenchLineups() async {
    var response = await http.get(
        "https://www.fotmob.com/matchDetails?matchId=${widget.matchID}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        benchLineUp = jsonresponse["content"]["lineup"]["lineup"];
        //print(benchLineUp);
        //print(PlayerLineUp);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getBenchLineups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return benchLineUp == null
        ? Center(
            child: SizedBox(),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: benchLineUp[widget.Mainindex]["bench"].length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  benchLineUp[widget.teamIndex]["bench"][index]["role"] ==
                              "Keeper" ||
                          benchLineUp[widget.teamIndex]["bench"][index]
                                  ["stats"] ==
                              null
                      ? Fluttertoast.showToast(
                          msg: "No Data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16.0,
                        )
                      : pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => IndStats(
                              name: benchLineUp[widget.teamIndex]["bench"]
                                  [index]["name"],
                              image: benchLineUp[widget.teamIndex]["bench"]
                                  [index]["imageUrl"],
                              played: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Minutes played"]
                                  .toString(),
                              ratings: benchLineUp[widget.teamIndex]["bench"]
                                          [index]["rating"]["num"] ==
                                      null
                                  ? "-"
                                  : benchLineUp[widget.teamIndex]["bench"]
                                          [index]["rating"]["num"]
                                      .toString(),
                              goals: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Goals"]
                                  .toString(),
                              assists: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Assists"]
                                  .toString(),
                              shots: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Total shots"]
                                  .toString(),
                              passes: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Accurate passes"]
                                  .toString(),
                              success: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Pass success"]
                                  .toString(),
                              chances: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["0"]["Chances created"]
                                  .toString(),
                              shotacc: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["1"]["Shot accuracy"]
                                  .toString(),
                              offTarget: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["1"]["Shot off target"]
                                  .toString(),
                              onTarget: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["1"]["Shot on target"]
                                  .toString(),
                              totalShots: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["1"]["Total shots"]
                                  .toString(),
                              accupasses: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["2"]["Accurate passes"]
                                  .toString(),
                              totalpasses: benchLineUp[widget.teamIndex]
                                      ["bench"][index]["stats"]["2"]["Passes"]
                                  .toString(),
                              keypasses: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["2"]["Key passes"]
                                  .toString(),
                              crosses: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["2"]["Crosses"]
                                  .toString(),
                              touch: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["2"]["Touches"]
                                  .toString(),
                              dbAttempt: benchLineUp[widget.teamIndex]["bench"]
                                          [index]["stats"]["3"]
                                      ["Dribbles attempted"]
                                  .toString(),
                              dbSuccess: benchLineUp[widget.teamIndex]["bench"]
                                          [index]["stats"]["3"]
                                      ["Dribbles succeeded"]
                                  .toString(),
                              disspossed: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Dispossessed"]
                                  .toString(),
                              fouled: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["was fouled"]
                                  .toString(),
                              fouls: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Fouls"]
                                  .toString(),
                              tacklesattmpt: benchLineUp[widget.teamIndex]
                                          ["bench"][index]["stats"]["3"]
                                      ["Tackles attempted"]
                                  .toString(),
                              tackleswon: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Tackles succeeded"]
                                  .toString(),
                              arielWon: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Aerials won"]
                                  .toString(),
                              arielLost: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Aerials lost"]
                                  .toString(),
                              interception: benchLineUp[widget.teamIndex]
                                          ["bench"][index]["stats"]["3"]
                                      ["Interceptions"]
                                  .toString(),
                              clearences: benchLineUp[widget.teamIndex]["bench"]
                                      [index]["stats"]["3"]["Clearances"]
                                  .toString(),
                            ),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: benchLineUp[widget.teamIndex]["bench"][index]
                            ["imageUrl"],
                        placeholder: (context, url) => new CachedNetworkImage(
                          fit: BoxFit.cover,
                          color: Colors.grey,
                          imageUrl:
                              "https://list.wiki/images/9/92/Unknown-avatar.png",
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    benchLineUp[widget.teamIndex]["bench"][index]["name"],
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        benchLineUp[widget.teamIndex]["bench"][index]["shirt"]
                            .toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        benchLineUp[widget.teamIndex]["bench"][index]["role"],
                        style: GoogleFonts.rubik(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    height: 20,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        benchLineUp[widget.teamIndex]["bench"][index]
                                        ["rating"] ==
                                    null ||
                                benchLineUp[widget.teamIndex]["bench"][index]
                                        ["rating"]["num"] ==
                                    null
                            ? " - "
                            : benchLineUp[widget.teamIndex]["bench"][index]
                                    ["rating"]["num"]
                                .toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
