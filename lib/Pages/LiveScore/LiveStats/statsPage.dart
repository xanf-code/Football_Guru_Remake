import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStats extends StatefulWidget {
  final int matchID;

  const LiveStats({Key key, this.matchID}) : super(key: key);
  @override
  _LiveStatsState createState() => _LiveStatsState();
}

class _LiveStatsState extends State<LiveStats>
    with AutomaticKeepAliveClientMixin<LiveStats> {
  List liveStats0;
  List liveStats1;
  List liveStats2;
  List liveStats3;
  List liveStats4;

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

  Future<String> GetStats() async {
    var response = await http.get(
        "https://www.fotmob.com/matchDetails?matchId=${widget.matchID}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        liveStats0 = jsonResponse["content"]["stats"]["stats"][0]["stats"];
        liveStats1 = jsonResponse["content"]["stats"]["stats"][1]["stats"];
        liveStats2 = jsonResponse["content"]["stats"]["stats"][2]["stats"];
        liveStats3 = jsonResponse["content"]["stats"]["stats"][3]["stats"];
        liveStats4 = jsonResponse["content"]["stats"]["stats"][4]["stats"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Timer statsTime;

  @override
  void initState() {
    statsTime = Timer.periodic(Duration(seconds: 15), (Timer t) => GetStats());
    super.initState();
  }

  @override
  void dispose() {
    statsTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return liveStats0 == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              stats(liveStats0),
              stats(liveStats1),
              stats(liveStats2),
              stats(liveStats3),
              stats(liveStats4),
            ],
          );
  }

  stats(List name) {
    return AnimationLimiter(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: name.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name[index]["stats"][0].toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            name[index]["title"],
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            name[index]["stats"][1].toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
