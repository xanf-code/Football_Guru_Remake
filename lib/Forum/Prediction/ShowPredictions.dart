import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/Prediction/AddPredictions.dart';
import 'package:transfer_news/Pages/home.dart';

class PredictNowScreen extends StatefulWidget {
  final String ID;
  final String team1Name;
  final String team1Logo;
  final String team2Name;
  final String team2Logo;
  final String count;
  const PredictNowScreen(
      {Key key,
      this.ID,
      this.team1Name,
      this.team1Logo,
      this.team2Name,
      this.team2Logo,
      this.count})
      : super(key: key);
  @override
  _PredictNowScreenState createState() => _PredictNowScreenState();
}

class _PredictNowScreenState extends State<PredictNowScreen> {
  int maxPredictionsToDisplay;
  ScrollController _scrollController;

  void initState() {
    maxPredictionsToDisplay = 30;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          maxPredictionsToDisplay += 30;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          title: Row(
            children: [
              CachedNetworkImage(
                height: 30,
                imageUrl: widget.team1Logo,
              ),
              SizedBox(
                width: 6,
              ),
              CachedNetworkImage(
                height: 30,
                imageUrl: widget.team2Logo,
              ),
              SizedBox(
                width: 6,
              ),
              Text("Prediction"),
            ],
          ),
        ),
        backgroundColor: Color(0xFF0e0e10),
        body: Stack(
          children: [
            ListView(
              //shrinkWrap: true,
              children: [
                buildHeader(),
                buildContent(),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  checkAndEnter();
                },
                child: DelayedDisplay(
                  slidingBeginOffset: const Offset(0, 1),
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
                        "Predict Now",
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
          ],
        ),
      ),
    );
  }

  checkAndEnter() async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Prediction")
        .doc(widget.ID)
        .get();
    if (docs.data()['usersVoted'].contains(currentUser.id)) {
      Fluttertoast.showToast(
        msg: "You have already predicted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      pushNewScreen(
        context,
        withNavBar: false,
        customPageRoute: MorpheusPageRoute(
          builder: (context) => AddPredictions(
            teamLogo1: widget.team1Logo,
            teamLogo2: widget.team2Logo,
            id: widget.ID,
            team1Name: widget.team1Name,
            team2Name: widget.team2Name,
          ),
          transitionDuration: Duration(
            milliseconds: 200,
          ),
        ),
      );
    }
  }

  buildHeader() {
    return DelayedDisplay(
      slidingBeginOffset: const Offset(0, -1),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 30,
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 25,
                    imageUrl: widget.team1Logo,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "-",
                    style: GoogleFonts.averageSans(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CachedNetworkImage(
                    height: 25,
                    imageUrl: widget.team2Logo,
                  )
                ],
              ),
              RichText(
                text: TextSpan(
                  text: widget.count,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Predictions',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildContent() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Prediction")
          .doc(widget.ID)
          .collection("allPredictions")
          .orderBy(
            "timestamp",
            descending: true,
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Text(
                "No Predictions :( ",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
            ),
            child: AnimationLimiter(
              child: ListView.builder(
                controller: _scrollController,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot predictions = snapshot.data.docs[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: snapshot.data.docs.length,
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0082c8),
                                  const Color(0xFF7303c0),
                                  const Color(0xFF396afc),
                                  const Color(0xFF2948ff),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [
                                  0.0,
                                  1.0,
                                  0.0,
                                  1.0,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: CachedNetworkImageProvider(
                                      predictions.data()["url"],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // Expanded(
                                  //   child: Text(
                                  //     "${predictions.data()["name"]} has predicted ${widget.team1Name} ${predictions.data()["team1Score"]} - ${predictions.data()["team2Score"]} ${widget.team2Name}",
                                  //     style: GoogleFonts.openSans(
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${predictions.data()["name"]} has predicted ",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${widget.team1Name}  ${predictions.data()["team1Score"]} - ${predictions.data()["team2Score"]}  ${widget.team2Name}",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       "${predictions.data()["name"]} has predicted",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     CachedNetworkImage(
                                  //       height: 20,
                                  //       imageUrl: predictions.data()["team1Logo"],
                                  //     ),
                                  //     Text(
                                  //       " ${widget.team1Name} ",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       " ${predictions.data()["team1Score"]} ",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       "-",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       " ${predictions.data()["team2Score"]} ",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       " ${widget.team2Name} ",
                                  //       style: GoogleFonts.openSans(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     CachedNetworkImage(
                                  //       height: 20,
                                  //       imageUrl: predictions.data()["team2Logo"],
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
