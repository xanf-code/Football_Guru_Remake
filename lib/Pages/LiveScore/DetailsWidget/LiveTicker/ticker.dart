import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveTicker extends StatefulWidget {
  final int matchID;

  const LiveTicker({Key key, this.matchID}) : super(key: key);
  @override
  _LiveTickerState createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker>
    with AutomaticKeepAliveClientMixin<LiveTicker> {
  List liveTicker;

  Map<String, String> headers = {
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'referer': 'https://www.google.com/',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-site',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.100 Safari/537.36',
  };

  Future<String> getTicker() async {
    var response = await http.get(
        "https://data.fotmob.com/webcl/ltc/gsm/${widget.matchID}_en.json",
        //"https://data.fotmob.com/webcl/ltc/gsm/3424110_en.json",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        liveTicker = jsonresponse["Events"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Timer timer;

  @override
  void initState() {
    getTicker();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getTicker());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return liveTicker == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AnimationLimiter(
            child: ListView.builder(
              itemCount: liveTicker.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12.0,
                                        top: 8,
                                      ),
                                      child:
                                          liveTicker[index]["ElapsedPlus"] == -1
                                              ? Text(
                                                  "${liveTicker[index]["Elapsed"].toString()}'",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Text(
                                                  "${liveTicker[index]["Elapsed"].toString()} + ${liveTicker[index]["ElapsedPlus"].toString()} '",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _buildImage(index),
                                ],
                              ),
                              _buildChild(index),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    liveTicker[index]["Description"],
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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

  Widget _buildImage(int index) {
    if (liveTicker[index]["IncidentCode"] == "G") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 15,
        backgroundImage: CachedNetworkImageProvider(
          liveTicker[index]["Players"] == null
              ? ""
              : "https://images.fotmob.com/image_resources/playerimages/${liveTicker[index]["Players"][0]["Id"]}.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "PSG") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 15,
        backgroundImage: CachedNetworkImageProvider(
          liveTicker[index]["Players"] == null
              ? ""
              : "https://images.fotmob.com/image_resources/playerimages/${liveTicker[index]["Players"][0]["Id"]}.png",
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildChild(int index) {
    if (liveTicker[index]["IncidentCode"] == "SI") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 30,
          color: Colors.white,
          imageUrl:
              "https://img.pngio.com/substitution-icons-noun-project-substitute-png-200_200.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "miss") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 20,
          color: Colors.white,
          imageUrl: "https://static.thenounproject.com/png/200390-200.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "corner") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          color: Colors.white,
          imageUrl: "https://cdn.onlinewebfonts.com/svg/img_530987.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "attempt saved") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          color: Colors.white,
          imageUrl:
              "https://img.icons8.com/ios-filled/452/goalkeeper-with-net.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "G") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "GOAL",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "PSG") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          color: Colors.white,
          imageUrl: "https://static.thenounproject.com/png/542381-200.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "YC") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          //color: Colors.white,
          imageUrl:
              "https://images.vexels.com/media/users/3/146861/isolated/preview/dcafb4e33c5514e9b53b3d929501feaf-football-yellow-card-icon-by-vexels.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "RC") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          //color: Colors.white,
          imageUrl:
              "https://images.vexels.com/media/users/3/146857/isolated/preview/d55e89657228964a776f7dab3c0537ca-football-red-card-icon-by-vexels.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "start") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CachedNetworkImage(
          height: 25,
          color: Colors.white,
          imageUrl:
              "https://images.vexels.com/media/users/3/145122/isolated/preview/740170ea9599e23392d8072d674b3365-sport-whistle-icon-american-football-by-vexels.png",
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "end 1") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "HT",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "end 2") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "FT",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "half time") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "HT",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "full time") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "FT",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (liveTicker[index]["IncidentCode"] == "AS") {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "FT",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Text("");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
