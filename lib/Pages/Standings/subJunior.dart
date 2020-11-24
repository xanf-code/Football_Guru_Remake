import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Widgets/GroupsWidget.dart';
import 'package:transfer_news/Widgets/StandingsTable.dart';

class SubJuniorStandings extends StatefulWidget {
  @override
  _SubJuniorStandingsState createState() => _SubJuniorStandingsState();
}

class _SubJuniorStandingsState extends State<SubJuniorStandings>
    with AutomaticKeepAliveClientMixin<SubJuniorStandings> {
  String urlPath = "https://www.the-aiff.com/api/competition/points-table/5";

  List subjuniorData;

  Future<String> getsubJuniorStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        subjuniorData = jsonresponse["points_table"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getsubJuniorStanding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: ReusableWidgets.getAppBar(
          "Season\n2020/21",
          "https://www.the-aiff.com/assets/images/testimg.png",
          Colors.transparent),
      body: subjuniorData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][0]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][0]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][0]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][0]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][0]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][0]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][0]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][0]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][0]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][1]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][1]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][1]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][1]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][1]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][1]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][1]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][1]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][1]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][2]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][2]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][2]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][2]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][2]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][2]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][2]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][2]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][2]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][3]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][3]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][3]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][3]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][3]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][3]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][3]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][3]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][3]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][4]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][4]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][4]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][4]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][4]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][4]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][4]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][4]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][4]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][5]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][5]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][5]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][5]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][5]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][5]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][5]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][5]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][5]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][6]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][6]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][6]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][6]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][6]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][6]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][6]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][6]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][6]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][7]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][7]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][7]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][7]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][7]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][7]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][7]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][7]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][7]["points_table"]
                              [index]["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: subjuniorData[0]["groups"][8]["group_name"],
                  sub: subjuniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      subjuniorData[0]["groups"][8]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: subjuniorData[0]["groups"][8]["points_table"][index]
                          ["team_name"],
                      logo: subjuniorData[0]["groups"][8]["points_table"][index]
                          ["team_logo"],
                      played: subjuniorData[0]["groups"][8]["points_table"]
                              [index]["played"]
                          .toString(),
                      won: subjuniorData[0]["groups"][8]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: subjuniorData[0]["groups"][8]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: subjuniorData[0]["groups"][8]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: subjuniorData[0]["groups"][8]["points_table"]
                              [index]["points"]
                          .toString(),
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
