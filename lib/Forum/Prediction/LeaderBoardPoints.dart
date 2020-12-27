import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderPoints extends StatefulWidget {
  final String type;
  final String docID;

  const LeaderPoints({Key key, this.docID, this.type}) : super(key: key);
  @override
  _LeaderPointsState createState() => _LeaderPointsState();
}

class _LeaderPointsState extends State<LeaderPoints> {
  String score1;
  String score2;
  bool isVisible = true;
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.type)
              .doc(widget.docID)
              .collection("allPredictions")
              .where("query", isEqualTo: "${score1}-${score2}")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
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
                                      // CachedNetworkImage(
                                      //   imageUrl: docs,
                                      // ),
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot docs = snapshot.data.docs[index];
                      return docs.data()["pointsAssigned"] == false
                          ? ListTile(
                              subtitle: Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    imageUrl: docs.data()["team1Logo"],
                                  ),
                                  Text(
                                    docs.data()["team1Score"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    " - ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    docs.data()["team2Score"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  CachedNetworkImage(
                                    height: 20,
                                    imageUrl: docs.data()["team2Logo"],
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  docs.data()["url"],
                                ),
                              ),
                              title: Text(
                                docs.data()["name"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: FlatButton(
                                color: Colors.transparent,
                                child: Text(
                                  "+5",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  incrementPoint(
                                    docs.data()["ownerID"],
                                    widget.docID,
                                    docs.data()["Id"],
                                  );
                                },
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  incrementPoint(String userID, String predID, String postID) async {
    FirebaseFirestore.instance.collection("LearderBoard").doc(userID).update(
      {
        "points": FieldValue.increment(5),
      },
    ).whenComplete(() {
      FirebaseFirestore.instance
          .collection(widget.type)
          .doc(predID)
          .collection("allPredictions")
          .doc(postID)
          .update(
        {
          "pointsAssigned": true,
        },
      );
      setState(() {
        isVisible = false;
      });
    });
  }
}
