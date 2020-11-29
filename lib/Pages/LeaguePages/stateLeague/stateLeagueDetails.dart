import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/LeaguePages/StateFixtureWidget/stateFixWidget.dart';
import 'package:transfer_news/Pages/LeaguePages/stateLeagueGroups/leagueGroupswidget.dart';

class StateLeagueDetails extends StatefulWidget {
  final String appbarTitle;
  final String reference;
  const StateLeagueDetails({Key key, this.appbarTitle, this.reference})
      : super(key: key);
  @override
  _StateLeagueDetailsState createState() => _StateLeagueDetailsState();
}

class _StateLeagueDetailsState extends State<StateLeagueDetails>
    with AutomaticKeepAliveClientMixin<StateLeagueDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          title: Text(widget.appbarTitle),
          backgroundColor: Color(0xFF0e0e10),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Container(
              padding: EdgeInsets.only(
                right: 12,
                left: 4,
                bottom: 12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
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
                      text: "Fixtures",
                    ),
                    Tab(
                      text: "Groups",
                    ),
                    Tab(
                      text: "Stats",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            displayFixtures(),
            StateLeagueGroups(
              reference: widget.reference,
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  displayFixtures() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("State Fixtures")
          .doc(widget.reference)
          .collection("Fixtures")
          .orderBy("fixID")
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: dataSnapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot details = dataSnapshot.data.docs[index];
            return StateFixtureCards(
              team1Name: details.data()["Team A"],
              team1Logo: details.data()["Team A Logo"] == ""
                  ? "https://images.vexels.com/media/users/3/142810/isolated/preview/ba0c22cef0e0d4a277d74333536482d9-shield-emblem-logo-by-vexels.png"
                  : details.data()["Team A Logo"],
              team1Score: details.data()["Team A Score"] == ""
                  ? "-"
                  : details.data()["Team A Score"],
              team2Name: details.data()["Team B"],
              team2Logo: details.data()["Team B Logo"] == ""
                  ? "https://images.vexels.com/media/users/3/142810/isolated/preview/ba0c22cef0e0d4a277d74333536482d9-shield-emblem-logo-by-vexels.png"
                  : details.data()["Team B Logo"],
              team2Score: details.data()["Team B Score"] == ""
                  ? "-"
                  : details.data()["Team B Score"],
              date: details.data()["Date"],
              eventVenue: details.data()["Type"],
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
