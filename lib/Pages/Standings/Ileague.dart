import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;

class IleagueStandings extends StatefulWidget {
  @override
  _IleagueStandingsState createState() => _IleagueStandingsState();
}

class _IleagueStandingsState extends State<IleagueStandings>
    with AutomaticKeepAliveClientMixin<IleagueStandings> {
  String urlPath =
      "https://www.fotmob.com/leagues?id=8982&tab=table&type=league&timeZone=Asia%2FCalcutta&seo=super-league";

  List ilData;

  Future<String> getIleagueStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        ilData = jsonresponse["tableData"]["tables"][0]["table"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getIleagueStanding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: ReusableWidgets.getAppBar(
          "Season\n2020/21",
          "https://upload.wikimedia.org/wikipedia/en/thumb/7/72/I-League_logo.svg/1200px-I-League_logo.svg.png",
          Colors.transparent),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Text(
                        'Team',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PL',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'W',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'D',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'L',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Pts',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ilData == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ilData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  ilData[index]["idx"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 20,
                                      width: 20,
                                      imageUrl:
                                          "https://www.fotmob.com/images/team/${ilData[index]["id"]}_small",
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ilData[index]["name"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ilData[index]["played"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  ilData[index]["wins"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  ilData[index]["draws"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  ilData[index]["losses"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  ilData[index]["pts"].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
