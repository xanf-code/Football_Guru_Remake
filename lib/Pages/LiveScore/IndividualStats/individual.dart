import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class IndStats extends StatelessWidget {
  final String name;
  final String image;
  final String played;
  final String goals;
  final String assists;
  final String shots;
  final String passes;
  final String success;
  final String chances;
  final String ratings;
  final String shotacc;
  final String offTarget;
  final String onTarget;
  final String totalShots;
  final String totalpasses;
  final String accupasses;
  final String crosses;
  final String keypasses;
  final String touch;
  final String dWon;
  final String dLost;
  final String clearences;
  final String dbAttempt;
  final String dbSuccess;
  final String disspossed;
  final String fouled;
  final String fouls;
  final String tacklesattmpt;
  final String tackleswon;
  final String arielWon;
  final String arielLost;
  final String interception;
  const IndStats(
      {Key key,
      this.name,
      this.image,
      this.played,
      this.goals,
      this.assists,
      this.shots,
      this.passes,
      this.success,
      this.chances,
      this.ratings,
      this.shotacc,
      this.offTarget,
      this.onTarget,
      this.totalShots,
      this.totalpasses,
      this.accupasses,
      this.crosses,
      this.keypasses,
      this.touch,
      this.dWon,
      this.dLost,
      this.clearences,
      this.dbAttempt,
      this.dbSuccess,
      this.disspossed,
      this.fouled,
      this.fouls,
      this.tacklesattmpt,
      this.tackleswon,
      this.arielWon,
      this.arielLost,
      this.interception})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text(name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 18,
            ),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.blueAccent,
              child: Text(
                "LIVE",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 60,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: image,
                fadeInCurve: Curves.easeIn,
                placeholder: (context, url) => new CachedNetworkImage(
                  fit: BoxFit.cover,
                  color: Colors.grey,
                  imageUrl:
                      "https://www.pinclipart.com/picdir/big/357-3579339_unknown-person-icon-png-wordpress-clipart.png",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              name,
              style: GoogleFonts.averageSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Center(
            child: Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  ratings,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[800],
            indent: 60,
            endIndent: 60,
          ),
          Stats(
            context,
            "Minutes Played",
            played,
          ),
          Stats(
            context,
            "Goals",
            goals,
          ),
          Stats(
            context,
            "Assists",
            assists,
          ),
          Stats(
            context,
            "Total shots",
            shots,
          ),
          Stats(
            context,
            "Accurate passes",
            passes,
          ),
          Stats(
            context,
            "Pass Success",
            success,
          ),
          Stats(
            context,
            "Chances created",
            chances,
          ),
          Stats(
            context,
            "Shot accuracy",
            shotacc,
          ),
          Stats(
            context,
            "Shot off target",
            offTarget,
          ),
          Stats(
            context,
            "Shot on target",
            onTarget,
          ),
          Stats(
            context,
            "Total Shots",
            totalShots,
          ),
          Stats(
            context,
            "Total Passes",
            totalpasses,
          ),
          Stats(
            context,
            "Accurate Passes",
            accupasses,
          ),
          Stats(
            context,
            "Crosses",
            crosses,
          ),
          Stats(
            context,
            "Key Passes",
            keypasses,
          ),
          Stats(
            context,
            "Touches",
            touch,
          ),
          Stats(
            context,
            "Clearances",
            clearences,
          ),
          Stats(
            context,
            "Dribbles attempted",
            dbAttempt,
          ),
          Stats(
            context,
            "Dribbles succeeded",
            dbSuccess,
          ),
          Stats(
            context,
            "Dispossessed",
            disspossed,
          ),
          Stats(
            context,
            "Was Fouled",
            fouled,
          ),
          Stats(
            context,
            "Fouls",
            fouls,
          ),
          Stats(
            context,
            "Tackles attempted",
            tacklesattmpt,
          ),
          Stats(
            context,
            "Tackles succeeded",
            tackleswon,
          ),
          Stats(
            context,
            "Aerials won",
            arielWon,
          ),
          Stats(
            context,
            "Aerials lost",
            arielLost,
          ),
          Stats(
            context,
            "Interceptions",
            interception,
          ),
        ],
      ),
    );
  }

  Stats(context, String type, String attr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: 30,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF396afc),
              const Color(0xFF2948ff),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
              child: Text(
                type,
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                attr == "null" ? "-" : attr,
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
