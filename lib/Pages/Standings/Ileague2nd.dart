import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;

class Ileague2ndStandings extends StatefulWidget {
  @override
  _Ileague2ndStandingsState createState() => _Ileague2ndStandingsState();
}

class _Ileague2ndStandingsState extends State<Ileague2ndStandings>
    with AutomaticKeepAliveClientMixin<Ileague2ndStandings> {
  String urlPath = "https://www.the-aiff.com/api/competition/points-table/6";

  List il2Data;

  Future<String> getIleagueStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        il2Data = jsonresponse["points_table"];
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
          "https://upload.wikimedia.org/wikipedia/en/4/47/I-League_2nd_Division_Logo_2015.png",
          Colors.transparent),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              "Group A",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Preliminary Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupA(),
          ListTile(
            title: Text(
              "Group B",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Preliminary Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupB(),
          ListTile(
            title: Text(
              "Group C",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Preliminary Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupC(),
        ],
      ),
    );
  }

  ListView GroupA() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
        il2Data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: il2Data[0]["groups"][0]["points_table"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Octicons.dash,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    width: 20,
                                    imageUrl: il2Data[0]["groups"][0]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : il2Data[0]["groups"][0]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      il2Data[0]["groups"][0]["points_table"]
                                          [index]["team_name"],
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
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
                                il2Data[0]["groups"][0]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][0]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][0]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][0]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][0]["points_table"][index]
                                        ["points"]
                                    .toString(),
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
    );
  }

  ListView GroupB() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
        il2Data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: il2Data[0]["groups"][1]["points_table"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Octicons.dash,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    width: 20,
                                    imageUrl: il2Data[0]["groups"][1]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : il2Data[0]["groups"][1]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      il2Data[0]["groups"][1]["points_table"]
                                          [index]["team_name"],
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
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
                                il2Data[0]["groups"][1]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][1]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][1]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][1]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][1]["points_table"][index]
                                        ["points"]
                                    .toString(),
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
    );
  }

  ListView GroupC() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
        il2Data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: il2Data[0]["groups"][2]["points_table"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Octicons.dash,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    width: 20,
                                    imageUrl: il2Data[0]["groups"][2]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : il2Data[0]["groups"][2]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      il2Data[0]["groups"][2]["points_table"]
                                          [index]["team_name"],
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
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
                                il2Data[0]["groups"][2]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][2]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][2]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][2]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                il2Data[0]["groups"][2]["points_table"][index]
                                        ["points"]
                                    .toString(),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
