import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:http/http.dart' as http;

class ACLStandings extends StatefulWidget {
  @override
  _ACLStandingsState createState() => _ACLStandingsState();
}

class _ACLStandingsState extends State<ACLStandings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                isScrollable: true, //up to your taste
                indicator: DotIndicator(
                  color: Colors.white,
                  distanceFromCenter: 16,
                  radius: 3,
                  paintingStyle: PaintingStyle.stroke,
                ),
                tabs: <Widget>[
                  Tab(
                    text: "Group A",
                  ),
                  Tab(
                    text: "Group B",
                  ),
                  Tab(
                    text: "Group C",
                  ),
                  Tab(
                    text: "Group D",
                  ),
                  Tab(
                    text: "Group E",
                  ),
                  Tab(
                    text: "Group F",
                  ),
                  Tab(
                    text: "Group G",
                  ),
                  Tab(
                    text: "Group H",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            GroupStandingWidget(
              group: 0,
            ),
            GroupStandingWidget(
              group: 1,
            ),
            GroupStandingWidget(
              group: 2,
            ),
            GroupStandingWidget(
              group: 3,
            ),
            GroupStandingWidget(
              group: 4,
            ),
            GroupStandingWidget(
              group: 5,
            ),
            GroupStandingWidget(
              group: 6,
            ),
            GroupStandingWidget(
              group: 7,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupStandingWidget extends StatefulWidget {
  final int group;

  const GroupStandingWidget({Key key, this.group}) : super(key: key);
  @override
  _GroupStandingWidgetState createState() => _GroupStandingWidgetState();
}

class _GroupStandingWidgetState extends State<GroupStandingWidget>
    with AutomaticKeepAliveClientMixin<GroupStandingWidget> {
  String urlPath =
      "https://www.fotmob.com/leagues?id=525&tab=table&type=league&timeZone=Asia%2FCalcutta&seo=afc-cup";

  List afcCupData;

  Future<String> getAFCCupStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        afcCupData = jsonresponse["tableData"]["tables"][0]["tables"]
            [widget.group]["table"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAFCCupStanding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Team',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PL',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'W',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'D',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'L',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Pts',
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        afcCupData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: afcCupData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    afcCupData[index]["idx"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                        height: 20,
                                        width: 20,
                                        imageUrl:
                                            "https://www.fotmob.com/images/team/${afcCupData[index]["id"]}_small",
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        afcCupData[index]["name"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    afcCupData[index]["played"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    afcCupData[index]["wins"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    afcCupData[index]["draws"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    afcCupData[index]["losses"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    afcCupData[index]["pts"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
