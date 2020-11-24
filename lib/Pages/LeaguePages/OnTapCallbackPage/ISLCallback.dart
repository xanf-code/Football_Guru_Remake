import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:transfer_news/Pages/LeaguePages/ISLFixtureWidget/Fixture.dart';
import 'package:transfer_news/Pages/Standings/IndianSuperLeague.dart';
import 'package:transfer_news/Pages/Stats/ISLStats.dart';
import 'package:transfer_news/Pages/constants/constants.dart';

class ISLCallBack extends StatefulWidget {
  @override
  _ISLCallBackState createState() => _ISLCallBackState();
}

class _ISLCallBackState extends State<ISLCallBack> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          title: Text("Indian Super League"),
          backgroundColor: Color(0xFF0e0e10),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                isScrollable: true,
                indicator: DotIndicator(
                  color: Colors.white,
                  distanceFromCenter: 16,
                  radius: 3,
                  paintingStyle: PaintingStyle.fill,
                ),
                tabs: <Widget>[
                  Tab(
                    text: "Fixtures",
                  ),
                  Tab(
                    text: "Standings",
                  ),
                  Tab(
                    text: "Stats",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    elevation: 10,
                    value: selectedValue,
                    items: dropDownItem(),
                    onChanged: (value) {
                      selectedValue = value;
                      switch (value) {
                        case "league":
                          setState(() {
                            Fixture(
                              type: value,
                            );
                          });
                          break;
                        case "semi_final":
                          setState(() {
                            Fixture(
                              type: value,
                            );
                          });
                          break;
                        case "final":
                          setState(() {
                            Fixture(
                              type: value,
                            );
                          });
                          break;
                      }
                    },
                    dropdownColor: Color(0xFF0e0e10),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                    ),
                    hint: Text(
                      'Select type',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Fixture(
                  type: selectedValue,
                ),
              ],
            ),
            ISLPointsTable(),
            Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    elevation: 10,
                    value: selectedType,
                    items: ISLStatsItems(),
                    onChanged: (value) {
                      selectedType = value;
                      switch (value) {
                        case "goals":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "goal_assist":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "rating":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "goal_assists":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "mins_played_goa":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "total_att_assist":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "accurate_pass":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "big_chance_created":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "clean_sheet":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "effective_clearance":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "saves":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "yellow_card":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "won_tackle":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "red_card":
                          setState(() {
                            ISLStats(
                              type: value,
                            );
                          });
                          break;
                        case "default":
                          setState(() {
                            ISLStats(
                              type: "goals",
                            );
                          });
                      }
                    },
                    dropdownColor: Color(0xFF0e0e10),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                    ),
                    hint: Text(
                      'Select type',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ISLStats(
                  type: selectedType,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
