import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/Prediction/addEvent.dart';
import 'package:transfer_news/Pages/home.dart';

import 'LeaderBoardPoints.dart';
import 'ShowPredictions.dart';

class ISLPrediction extends StatefulWidget {
  @override
  _ISLPredictionState createState() => _ISLPredictionState();
}

class _ISLPredictionState extends State<ISLPrediction> {
  bool isLocked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: currentUser.isAdmin == true
            ? FloatingActionButton(
                heroTag: null,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Icon(
                    MaterialCommunityIcons.sword_cross,
                    size: 30,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xffF58529),
                        Color(0xffFEDA77),
                        Color(0xffDD2A7B),
                        Color(0xff8134AF),
                        Color(0xff515BD4),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => AddEvent(),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
              )
            : SizedBox.shrink(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Prediction").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://cdn1.iconfinder.com/data/icons/halloween-2323/135/38-512.png",
                    width: 250,
                  ),
                  Text(
                    "No Predictions open yet.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot cards = snapshot.data.docs[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => LeaderPoints(
                              docID: cards.data()["Id"],
                            ),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        cards.data()["status"] == false
                            ? pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => PredictNowScreen(
                                    ID: cards.data()["Id"],
                                    team1Name: cards.data()["team1Name"],
                                    team1Logo: cards.data()["team1Logo"],
                                    team2Name: cards.data()["team2Name"],
                                    team2Logo: cards.data()["team2Logo"],
                                    count: cards
                                        .data()["usersVoted"]
                                        .length
                                        .toString(),
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              )
                            : CoolAlert.show(
                                context: context,
                                type: CoolAlertType.info,
                                text:
                                    "Predictions for closed, Leaderboard will be updated soon.",
                                lottieAsset: '/assets/animation/closed.json',
                                backgroundColor: Colors.black,
                              );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                height: 50,
                                imageUrl: cards.data()["team1Logo"],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                cards.data()["team1Name"],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "VS",
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                cards.data()["team2Name"],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              CachedNetworkImage(
                                height: 50,
                                imageUrl: cards.data()["team2Logo"],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    currentUser.isAdmin == true
                        ? Positioned(
                            right: 0,
                            child: IconButton(
                              icon: cards.data()["status"] == true
                                  ? Icon(
                                      Feather.lock,
                                      color: Colors.black,
                                      size: 18,
                                    )
                                  : Icon(
                                      Feather.unlock,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                //Status : false (UNLOCKED CAN VOTE)
                                //Status : true (LOCKED CAN'T VOTE)
                                manageLocking(
                                  cards.data()["Id"],
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                    currentUser.isAdmin == true
                        ? Positioned(
                            left: 0,
                            child: IconButton(
                              icon: Icon(
                                EvilIcons.close_o,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                removeEvent(
                                  cards.data()["Id"],
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  removeEvent(String ID) {
    FirebaseFirestore.instance
        .collection('Prediction')
        .doc(ID)
        .collection("allPredictions")
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      }
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('Prediction')
          .doc(ID)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    });
  }

  manageLocking(String id) async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection("Prediction").doc(id).get();
    if (docs.data()["status"] == true) {
      FirebaseFirestore.instance.collection("Prediction").doc(id).update({
        'status': false,
      });
    } else {
      FirebaseFirestore.instance.collection("Prediction").doc(id).update({
        'status': true,
      });
    }
  }
}
