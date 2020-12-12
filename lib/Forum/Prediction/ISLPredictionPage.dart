import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:transfer_news/Forum/Prediction/addEvent.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:intl/intl.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'LeaderBoardPoints.dart';
import 'ShowPredictions.dart';

class ISLPrediction extends StatefulWidget {
  const ISLPrediction({Key key}) : super(key: key);
  @override
  _ISLPredictionState createState() => _ISLPredictionState();
}

class _ISLPredictionState extends State<ISLPrediction>
    with AutomaticKeepAliveClientMixin<ISLPrediction> {
  @override
  bool get wantKeepAlive => true;
  bool isLocked = false;
  Stream predStream;

  @override
  void initState() {
    predStream =
        FirebaseFirestore.instance.collection("Prediction").snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Visibility(
            visible: currentUser.isAdmin == true ? true : false,
            child: FloatingActionButton(
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
            ),
          )),
      body: StreamBuilder(
        stream: predStream,
        builder: (context, snapshot) {
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
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot cards = snapshot.data.docs[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: snapshot.data.docs.length,
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 32,
                              right: 25,
                              child: Container(
                                width: 80,
                                height: 35,
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
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "PREDICT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onLongPress: () {
                                currentUser.isAdmin == true
                                    ? pushNewScreen(
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
                                      )
                                    : HapticFeedback.mediumImpact();
                              },
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                cards.data()["status"] == false
                                    ? pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        customPageRoute: MorpheusPageRoute(
                                          builder: (context) =>
                                              PredictNowScreen(
                                            ID: cards.data()["Id"],
                                            team1Name:
                                                cards.data()["team1Name"],
                                            team1Logo:
                                                cards.data()["team1Logo"],
                                            team2Name:
                                                cards.data()["team2Name"],
                                            team2Logo:
                                                cards.data()["team2Logo"],
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
                                    : showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          //backgroundColor: tagBorder,
                                          message:
                                              "Predictions are closed, LeaderBoard will be updated soon.",
                                        ),
                                      );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: tagBorder,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12.0,
                                              top: 12,
                                              bottom: 12,
                                            ),
                                            child: Container(
                                              width: 70,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: new LinearGradient(
                                                  colors: [
                                                    const Color(0xFFb92b27),
                                                    const Color(0xFF1565C0),
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  cards.data()["status"] == true
                                                      ? "CLOSED"
                                                      : "OPEN",
                                                  style:
                                                      GoogleFonts.averageSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 14.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MaterialCommunityIcons.poll,
                                                  color: IconColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${NumberFormat.compact().format(cards.data()["usersVoted"].length)} predictions",
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          "${cards.data()["team1Name"]} vs ${cards.data()["team2Name"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          bottom: 8,
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFe0f2f1),
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      "${cards.data()["team1Logo"]}_xsmall",
                                                    ),
                                                  ),
                                                  border: Border.all(
                                                    width: 3,
                                                    color: tagBorder,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 25,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xFFe0f2f1),
                                                    image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        "${cards.data()["team2Logo"]}_xsmall",
                                                      ),
                                                    ),
                                                    border: Border.all(
                                                      width: 3,
                                                      color: tagBorder,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  currentUser.isAdmin == true ? true : false,
                              child: Positioned(
                                top: 15,
                                left: 90,
                                child: IconButton(
                                  icon: cards.data()["status"] == true
                                      ? Icon(
                                          Feather.lock,
                                          color: Colors.red,
                                          size: 18,
                                        )
                                      : Icon(
                                          Feather.unlock,
                                          color: Colors.white,
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
                              ),
                            ),
                            Visibility(
                              visible:
                                  currentUser.isAdmin == true ? true : false,
                              child: Positioned(
                                left: 150,
                                top: 15,
                                child: IconButton(
                                  icon: Icon(
                                    EvilIcons.close_o,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    showAlertDialog(
                                      context,
                                      cards.data()["Id"],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, String ID) {
    Widget cancelButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Yes",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        removeEvent(
          ID,
        );
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        "Delete",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        "Are you sure you want to delete the event?",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
