import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Widgets/GroupsWidget.dart';
import 'package:transfer_news/Widgets/StandingsTable.dart';

class JuniorStandings extends StatefulWidget {
  @override
  _JuniorStandingsState createState() => _JuniorStandingsState();
}

class _JuniorStandingsState extends State<JuniorStandings>
    with AutomaticKeepAliveClientMixin<JuniorStandings> {
  String urlPath = "https://www.the-aiff.com/api/competition/points-table/4";

  List juniorData;

  Future<String> getjuniorStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        juniorData = jsonresponse["points_table"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getjuniorStanding();
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
      body: juniorData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                GroupWidget(
                  groupName: juniorData[0]["groups"][0]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][0]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][0]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][0]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][0]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][0]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][0]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][0]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][0]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][1]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][1]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][1]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][1]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][1]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][1]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][1]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][1]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][1]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][2]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][2]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][2]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][2]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][2]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][2]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][2]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][2]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][2]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][3]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][3]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][3]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][3]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][3]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][3]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][3]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][3]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][3]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][4]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][4]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][4]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][4]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][4]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][4]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][4]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][4]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][4]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][5]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][5]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][5]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][5]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][5]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][5]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][5]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][5]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][5]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][6]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][6]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][6]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][6]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][6]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][6]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][6]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][6]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][6]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][7]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][7]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][7]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][7]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][7]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][7]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][7]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][7]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][7]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][8]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][8]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][8]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][8]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][8]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][8]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][8]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][8]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][8]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][9]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][9]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][9]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][9]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][9]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][9]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][9]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][9]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][9]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][10]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][10]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][10]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][10]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][10]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][10]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][10]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][10]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][10]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: juniorData[0]["groups"][11]["group_name"],
                  sub: juniorData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: juniorData[0]["groups"][11]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: juniorData[0]["groups"][11]["points_table"][index]
                          ["team_name"],
                      logo: juniorData[0]["groups"][11]["points_table"][index]
                          ["team_logo"],
                      played: juniorData[0]["groups"][11]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: juniorData[0]["groups"][11]["points_table"][index]
                              ["won"]
                          .toString(),
                      draw: juniorData[0]["groups"][11]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: juniorData[0]["groups"][11]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: juniorData[0]["groups"][11]["points_table"][index]
                              ["points"]
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
