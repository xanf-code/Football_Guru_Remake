import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LiveScore/IndividualStats/GKind.dart';
import 'package:transfer_news/Pages/LiveScore/IndividualStats/individual.dart';

class Linups extends StatefulWidget {
  final int matchID;
  final int listIndex;
  const Linups({Key key, this.matchID, this.listIndex}) : super(key: key);
  @override
  _LinupsState createState() => _LinupsState();
}

class _LinupsState extends State<Linups> {
  List team = [];
  //List team2;
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
        team = jsonresponse["content"]["lineup"]["lineup"][widget.listIndex]
            ["players"];
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
    return team.length == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: team.length,
                itemBuilder: (context, index) {
                  final lineup1 = team[index];
                  return Column(
                    children: [
                      for (final l in lineup1)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            l["stats"] != null
                                ? pushNewScreen(
                                    context,
                                    withNavBar: false,
                                    customPageRoute: MorpheusPageRoute(
                                      builder: (context) => l["role"] ==
                                              "Keeper"
                                          ? IndGKStats(
                                              name: l["name"],
                                              image: l["imageUrl"],
                                              played: l["stats"]["0"]
                                                      ["Minutes played"]
                                                  .toString(),
                                              goals: l["stats"]["0"]
                                                      ["Goals conceded"]
                                                  .toString(),
                                              assists: l["stats"]["0"]["Saves"]
                                                  .toString(),
                                              shots: l["stats"]["0"]
                                                      ["Diving save"]
                                                  .toString(),
                                              chances: l["stats"]["0"]
                                                      ["Punches"]
                                                  .toString(),
                                              success: l["stats"]["0"]
                                                      ["Acted as sweeper"]
                                                  .toString(),
                                              passes: l["stats"]["0"]
                                                      ["Saves inside box"]
                                                  .toString(),
                                              ratings:
                                                  l["rating"]["num"] == null
                                                      ? '-'
                                                      : l["rating"]["num"],
                                              shotacc: l["stats"]["0"]["Throws"]
                                                  .toString(),
                                              onTarget: l["stats"]["1"]
                                                      ["Shot on target"]
                                                  .toString(),
                                              offTarget: l["stats"]["1"]
                                                      ["Shot off target"]
                                                  .toString(),
                                              totalShots: l["stats"]["1"]
                                                      ["Total shots"]
                                                  .toString(),
                                              totalpasses: l["stats"]["2"]
                                                      ["Passes"]
                                                  .toString(),
                                              accupasses: l["stats"]["2"]
                                                      ["Accurate passes"]
                                                  .toString(),
                                              crosses: l["stats"]["2"]
                                                      ["Crosses"]
                                                  .toString(),
                                              keypasses: l["stats"]["2"]
                                                      ["Key passes"]
                                                  .toString(),
                                              touch: l["stats"]["2"]["Touches"]
                                                  .toString(),
                                              dWon: l["stats"]["3"]["Duels won"]
                                                  .toString(),
                                              dLost: l["stats"]["3"]
                                                      ["Duels lost"]
                                                  .toString(),
                                              clearences: l["stats"]["3"]
                                                      ["Clearances"]
                                                  .toString(),
                                              dbAttempt: l["stats"]["3"]
                                                      ["Dribbles attempted"]
                                                  .toString(),
                                              dbSuccess: l["stats"]["3"]
                                                      ["Dribbles succeeded"]
                                                  .toString(),
                                              disspossed: l["stats"]["3"]
                                                      ["Dispossessed"]
                                                  .toString(),
                                              fouled: l["stats"]["3"]
                                                      ["Was fouled"]
                                                  .toString(),
                                              fouls: l["stats"]["3"]["Fouls"]
                                                  .toString(),
                                              tacklesattmpt: l["stats"]["3"]
                                                      ["Tackles attempted"]
                                                  .toString(),
                                              tackleswon: l["stats"]["3"]
                                                      ["Tackles succeeded"]
                                                  .toString(),
                                              arielWon: l["stats"]["3"]
                                                      ["Aerials won"]
                                                  .toString(),
                                              arielLost: l["stats"]["3"]
                                                      ["Aerials lost"]
                                                  .toString(),
                                              interception: l["stats"]["3"]
                                                      ["Interceptions"]
                                                  .toString(),
                                            )
                                          : IndStats(
                                              name: l["name"],
                                              image: l["imageUrl"],
                                              played: l["stats"]["0"]
                                                      ["Minutes played"]
                                                  .toString(),
                                              goals: l["stats"]["0"]["Goals"]
                                                  .toString(),
                                              assists: l["stats"]["0"]
                                                      ["Assists"]
                                                  .toString(),
                                              shots: l["stats"]["0"]
                                                      ["Total shots"]
                                                  .toString(),
                                              chances: l["stats"]["0"]
                                                      ["Chances created"]
                                                  .toString(),
                                              success: l["stats"]["0"]
                                                      ["Pass success"]
                                                  .toString(),
                                              passes: l["stats"]["0"]
                                                      ["Accurate passes"]
                                                  .toString(),
                                              ratings:
                                                  l["rating"]["num"] ?? "-",
                                              shotacc: l["stats"]["1"]
                                                      ["Shot accuracy"]
                                                  .toString(),
                                              onTarget: l["stats"]["1"]
                                                      ["Shot on target"]
                                                  .toString(),
                                              offTarget: l["stats"]["1"]
                                                      ["Shot off target"]
                                                  .toString(),
                                              totalShots: l["stats"]["1"]
                                                      ["Total shots"]
                                                  .toString(),
                                              totalpasses: l["stats"]["2"]
                                                      ["Passes"]
                                                  .toString(),
                                              accupasses: l["stats"]["2"]
                                                      ["Accurate passes"]
                                                  .toString(),
                                              crosses: l["stats"]["2"]
                                                      ["Crosses"]
                                                  .toString(),
                                              keypasses: l["stats"]["2"]
                                                      ["Key passes"]
                                                  .toString(),
                                              touch: l["stats"]["2"]["Touches"]
                                                  .toString(),
                                              dWon: l["stats"]["3"]["Duels won"]
                                                  .toString(),
                                              dLost: l["stats"]["3"]
                                                      ["Duels lost"]
                                                  .toString(),
                                              clearences: l["stats"]["3"]
                                                      ["Clearances"]
                                                  .toString(),
                                              dbAttempt: l["stats"]["3"]
                                                      ["Dribbles attempted"]
                                                  .toString(),
                                              dbSuccess: l["stats"]["3"]
                                                      ["Dribbles succeeded"]
                                                  .toString(),
                                              disspossed: l["stats"]["3"]
                                                      ["Dispossessed"]
                                                  .toString(),
                                              fouled: l["stats"]["3"]
                                                      ["Was fouled"]
                                                  .toString(),
                                              fouls: l["stats"]["3"]["Fouls"]
                                                  .toString(),
                                              tacklesattmpt: l["stats"]["3"]
                                                      ["Tackles attempted"]
                                                  .toString(),
                                              tackleswon: l["stats"]["3"]
                                                      ["Tackles succeeded"]
                                                  .toString(),
                                              arielWon: l["stats"]["3"]
                                                      ["Aerials won"]
                                                  .toString(),
                                              arielLost: l["stats"]["3"]
                                                      ["Aerials lost"]
                                                  .toString(),
                                              interception: l["stats"]["3"]
                                                      ["Interceptions"]
                                                  .toString(),
                                            ),
                                      transitionDuration: Duration(
                                        milliseconds: 200,
                                      ),
                                    ),
                                  )
                                : Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0,
                                  );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: l["imageUrl"],
                                  placeholder: (context, url) =>
                                      new CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    color: Colors.grey,
                                    imageUrl:
                                        "https://list.wiki/images/9/92/Unknown-avatar.png",
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              l["name"],
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  l["shirt"].toString(),
                                  style: GoogleFonts.rubik(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  l["role"],
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
                                  l["rating"]["num"] == null
                                      ? "-"
                                      : l["rating"]["num"].toString(),
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
  }
}
