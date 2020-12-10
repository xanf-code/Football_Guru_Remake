import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddPredictions extends StatefulWidget {
  final String teamLogo1;
  final String teamLogo2;
  final String team1Name;
  final String team2Name;
  final String id;

  const AddPredictions(
      {Key key,
      this.teamLogo1,
      this.teamLogo2,
      this.id,
      this.team1Name,
      this.team2Name})
      : super(key: key);
  @override
  _AddPredictionsState createState() => _AddPredictionsState();
}

class _AddPredictionsState extends State<AddPredictions> {
  String score1;
  String score2;
  String ID = Uuid().v4();
  List teamScores = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DelayedDisplay(
                    slidingBeginOffset: Offset(-1, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 30,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.teamLogo1,
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.team1Name,
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Colors.black,
                              isDense: true,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              hint: Text(
                                "Pick Score",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              value: score1,
                              onChanged: (val) {
                                setState(() {
                                  score1 = val;
                                });
                              },
                              items: teamScores.map((team) {
                                return DropdownMenuItem(
                                  child: SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          "$team",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: team,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DelayedDisplay(
                    slidingBeginOffset: Offset(-0.5, -1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 70.0,
                        left: 12,
                        right: 12,
                      ),
                      child: Text(
                        "X",
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    slidingBeginOffset: Offset(1, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 30,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.teamLogo2,
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.team2Name,
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Colors.black,
                              isDense: true,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              hint: Text(
                                "Pick Score",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              value: score2,
                              onChanged: (val) {
                                setState(() {
                                  score2 = val;
                                });
                              },
                              items: teamScores.map((team) {
                                return DropdownMenuItem(
                                  child: SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          "$team",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: team,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  isLoading = true;
                });
                saveToDatabase();
              },
              child: DelayedDisplay(
                slidingBeginOffset: Offset(0, 1),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 50,
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
                  child: Center(
                    child: Text(
                      "Submit",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          isLoading == true
              ? Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[800].withOpacity(0.3),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 170.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Center(
                            child: new CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  saveToDatabase() async {
    FirebaseFirestore.instance
        .collection("Prediction")
        .doc(widget.id)
        .collection("allPredictions")
        .doc(ID)
        .set({
      "Id": ID,
      "ownerID": currentUser.id,
      "url": currentUser.url,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "team1Logo": widget.teamLogo1,
      "team1Score": score1 == null ? 0 : score1,
      "team2Logo": widget.teamLogo2,
      "team2Score": score2 == null ? 0 : score2,
      "query": "${score1 == null ? 0 : score1}-${score2 == null ? 0 : score2}",
      "pointsAssigned": false,
    }).then((result) {
      FirebaseFirestore.instance.collection("Prediction").doc(widget.id).update(
        {
          'usersVoted': FieldValue.arrayUnion(
            [currentUser.id],
          ),
        },
      );
      learderBoard();
      setState(() {
        ID = Uuid().v4();
      });
      Navigator.pop(context);
    });
  }

  learderBoard() async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("LearderBoard")
        .doc(currentUser.id)
        .get();
    if (docs.exists) {
      FirebaseFirestore.instance
          .collection("LearderBoard")
          .doc(currentUser.id)
          .update({
        "name": currentUser.username,
        "ID": currentUser.id,
        "url": currentUser.url,
        //"points": 0,
      });
    } else {
      FirebaseFirestore.instance
          .collection("LearderBoard")
          .doc(currentUser.id)
          .set({
        "name": currentUser.username,
        "ID": currentUser.id,
        "url": currentUser.url,
        "points": 0,
      });
    }
  }
}
