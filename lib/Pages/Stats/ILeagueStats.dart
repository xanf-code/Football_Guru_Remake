import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:transfer_news/Pages/Stats/IleagueNested/IleagueAssists.dart';
import 'package:transfer_news/Pages/Stats/IleagueNested/IleagueGoals.dart';

class ILeagueStats extends StatefulWidget {
  @override
  _ILeagueStatsState createState() => _ILeagueStatsState();
}

class _ILeagueStatsState extends State<ILeagueStats> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    text: "Goals",
                  ),
                  Tab(
                    text: "Assists",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ILeagueGoals(),
            ILeagueAssists(),
          ],
        ),
      ),
    );
  }
}
