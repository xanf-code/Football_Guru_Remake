import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Widgets/GroupsWidget.dart';

class eliteStandings extends StatefulWidget {
  @override
  _eliteStandingsState createState() => _eliteStandingsState();
}

class _eliteStandingsState extends State<eliteStandings>
    with AutomaticKeepAliveClientMixin<eliteStandings> {
  String urlPath = "https://www.the-aiff.com/api/competition/points-table/3";

  List eliteData;

  Future<String> getIleagueStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        eliteData = jsonresponse["points_table"];
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
          "https://upload.wikimedia.org/wikipedia/en/b/ba/Youth_League_U18_logo.png",
          Colors.transparent),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          GroupWidget(
            groupName: "Group A",
            sub: "Qualifying Round",
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
              "Qualifying Round",
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
              "Qualifying Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupC(),
          ListTile(
            title: Text(
              "Group D",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Qualifying Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupD(),
          ListTile(
            title: Text(
              "Group E",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Qualifying Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupE(),
          ListTile(
            title: Text(
              "Group F",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Qualifying Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupF(),
          ListTile(
            title: Text(
              "Group G",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Qualifying Round",
              style: GoogleFonts.rubik(
                color: Colors.white,
              ),
            ),
          ),
          GroupG(),
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][0]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][0]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][0]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][0]["points_table"]
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
                                eliteData[0]["groups"][0]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][0]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][0]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][0]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][0]["points_table"][index]
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][1]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][1]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][1]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][1]["points_table"]
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
                                eliteData[0]["groups"][1]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][1]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][1]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][1]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][1]["points_table"][index]
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][2]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][2]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][2]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][2]["points_table"]
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
                                eliteData[0]["groups"][2]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][2]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][2]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][2]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][2]["points_table"][index]
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

  ListView GroupD() {
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][3]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][3]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][3]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][3]["points_table"]
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
                                eliteData[0]["groups"][3]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][3]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][3]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][3]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][3]["points_table"][index]
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

  ListView GroupE() {
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][4]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][4]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][4]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][4]["points_table"]
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
                                eliteData[0]["groups"][4]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][4]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][4]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][4]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][4]["points_table"][index]
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

  ListView GroupF() {
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][5]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][5]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][5]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][5]["points_table"]
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
                                eliteData[0]["groups"][5]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][5]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][5]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][5]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][5]["points_table"][index]
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

  ListView GroupG() {
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
        eliteData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eliteData[0]["groups"][6]["points_table"].length,
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
                                    imageUrl: eliteData[0]["groups"][6]
                                                    ["points_table"][index]
                                                ["team_logo"] ==
                                            ""
                                        ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                        : eliteData[0]["groups"][6]
                                                ["points_table"][index]
                                            ["team_logo"],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      eliteData[0]["groups"][6]["points_table"]
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
                                eliteData[0]["groups"][6]["points_table"][index]
                                        ["played"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][6]["points_table"][index]
                                        ["won"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][6]["points_table"][index]
                                        ["draw"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][6]["points_table"][index]
                                        ["lost"]
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                eliteData[0]["groups"][6]["points_table"][index]
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
