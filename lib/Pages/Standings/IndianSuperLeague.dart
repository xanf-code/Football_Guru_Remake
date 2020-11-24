import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Standings/ISLStandingDetails/standingsDetails.dart';

class ISLPointsTable extends StatefulWidget {
  final User gCurrentUser;

  const ISLPointsTable({this.gCurrentUser});
  @override
  _ISLPointsTableState createState() => _ISLPointsTableState();
}

class _ISLPointsTableState extends State<ISLPointsTable>
    with AutomaticKeepAliveClientMixin<ISLPointsTable> {
  String urlPath =
      "https://www.indiansuperleague.com/sifeeds/repo/football/live/india_sl/json/202_standings.json";

  List islData;
  bool _loading = true;

  Future<String> getISLStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        islData = jsonresponse["standings"]["groups"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getISLStanding();
    setState(() {
      _loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      body: islData == null
          ? LinearProgressIndicator()
          : ListView(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    top: 8,
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Teams",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "P",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "W",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "L",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "D",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "PTS",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      islData == null ? 0 : islData[0]["teams"]["team"].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MorpheusPageRoute(
                              builder: (context) => StandingsDetails(
                                name: islData[0]["teams"]["team"][index]
                                    ["team_name"],
                                image: islData[0]["teams"]["team"][index]
                                    ["team_id"],
                                played: islData[0]["teams"]["team"][index]
                                    ["played"],
                                won: islData[0]["teams"]["team"][index]["wins"],
                                draw: islData[0]["teams"]["team"][index]
                                    ["draws"],
                                lost: islData[0]["teams"]["team"][index]
                                    ["lost"],
                                gf: islData[0]["teams"]["team"][index]["gf"],
                                ga: islData[0]["teams"]["team"][index]["ga"],
                                gd: islData[0]["teams"]["team"][index]
                                    ["score_diff"],
                                points: islData[0]["teams"]["team"][index]
                                    ["points"],
                                currentPosition: islData[0]["teams"]["team"]
                                    [index]["position"],
                                prevPosition: islData[0]["teams"]["team"][index]
                                    ["prev_position"],
                              ),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: islData[0]["teams"]["team"][index]
                                            ["position"] ==
                                        "1" ||
                                    islData[0]["teams"]["team"][index]
                                            ["position"] ==
                                        "2" ||
                                    islData[0]["teams"]["team"][index]
                                            ["position"] ==
                                        "3" ||
                                    islData[0]["teams"]["team"][index]
                                            ["position"] ==
                                        "4"
                                ? Colors.grey[900]
                                : Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: islData[0]["teams"]["team"][index]
                                              ["position"] ==
                                          "10" ||
                                      islData[0]["teams"]["team"][index]
                                              ["position"] ==
                                          "11"
                                  ? 6.0
                                  : 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      islData[0]["teams"]["team"][index]
                                                      ["position"] ==
                                                  "1" ||
                                              islData[0]["teams"]["team"][index]
                                                      ["position"] ==
                                                  "2" ||
                                              islData[0]["teams"]["team"][index]
                                                      ["position"] ==
                                                  "3" ||
                                              islData[0]["teams"]["team"][index]
                                                      ["position"] ==
                                                  "4"
                                          ? Text(
                                              islData[0]["teams"]["team"][index]
                                                  ["position"],
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            )
                                          : Text(
                                              islData[0]["teams"]["team"][index]
                                                  ["position"],
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                //fontSize: 20,
                                              ),
                                            ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CachedNetworkImage(
                                        height: 40,
                                        imageUrl:
                                            "https://www.indiansuperleague.com/static-resources/images/clubs/small/${islData[0]["teams"]["team"][index]["team_id"]}.png?v=1.92",
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                                      ["team_name"] ==
                                                  "NorthEast United FC"
                                              ? "NorthEast Utd FC"
                                              : islData[0]["teams"]["team"]
                                                  [index]["team_name"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                              ["played"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                              ["wins"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                              ["lost"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                              ["tied"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          islData[0]["teams"]["team"][index]
                                              ["points"],
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
