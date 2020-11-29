import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/LeaguePages/stateLeague/stateLeagueDetails.dart';

class StatesLeague extends StatefulWidget {
  @override
  _StatesLeagueState createState() => _StatesLeagueState();
}

class _StatesLeagueState extends State<StatesLeague> {
  Stream fixtures;
  @override
  void initState() {
    fixtures =
        FirebaseFirestore.instance.collection("State Fixtures").snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fixtures,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot fix = snapshot.data.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    pushNewScreen(
                      context,
                      withNavBar: false,
                      customPageRoute: MorpheusPageRoute(
                        builder: (context) => StateLeagueDetails(
                          appbarTitle: fix.data()["leagueName"],
                          reference: fix.data()["ref"],
                        ),
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                      ),
                    );
                  },
                  child: StateFixCard(
                    fixtures: fix,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class StateFixCard extends StatelessWidget {
  const StateFixCard({
    Key key,
    @required this.fixtures,
  }) : super(key: key);

  final DocumentSnapshot fixtures;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(
              fixtures.data()["leagueLogo"],
            ),
          ),
          title: Text(
            fixtures.data()["leagueName"],
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              fixtures.data()["year"],
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "See More",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
