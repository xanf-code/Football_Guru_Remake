import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:transfer_news/Widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Widgets/GroupsWidget.dart';
import 'package:transfer_news/Widgets/StandingsTable.dart';

class IWLStandings extends StatefulWidget {
  @override
  _IWLStandingsState createState() => _IWLStandingsState();
}

class _IWLStandingsState extends State<IWLStandings>
    with AutomaticKeepAliveClientMixin<IWLStandings> {
  String urlPath = "https://www.the-aiff.com/api/competition/points-table/11";

  List IWLData;

  Future<String> getIWLStanding() async {
    var response = await http.get(urlPath);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        IWLData = jsonresponse["points_table"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getIWLStanding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: ReusableWidgets.getAppBar(
          "Season\n2019/20",
          "https://upload.wikimedia.org/wikipedia/en/e/e0/Indian_Women%27s_League_Logo.png",
          Colors.transparent),
      body: IWLData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                GroupWidget(
                  groupName: IWLData[0]["stage_name"],
                  sub: IWLData[0]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: IWLData[0]["groups"][0]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: IWLData[0]["groups"][0]["points_table"][index]
                          ["team_name"],
                      logo: IWLData[0]["groups"][0]["points_table"][index]
                          ["team_logo"],
                      played: IWLData[0]["groups"][0]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: IWLData[0]["groups"][0]["points_table"][index]["won"]
                          .toString(),
                      draw: IWLData[0]["groups"][0]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: IWLData[0]["groups"][0]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: IWLData[0]["groups"][0]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: IWLData[1]["groups"][0]["group_name"],
                  sub: IWLData[1]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: IWLData[1]["groups"][0]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: IWLData[1]["groups"][0]["points_table"][index]
                          ["team_name"],
                      logo: IWLData[1]["groups"][0]["points_table"][index]
                          ["team_logo"],
                      played: IWLData[1]["groups"][0]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: IWLData[1]["groups"][0]["points_table"][index]["won"]
                          .toString(),
                      draw: IWLData[1]["groups"][0]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: IWLData[1]["groups"][0]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: IWLData[1]["groups"][0]["points_table"][index]
                              ["points"]
                          .toString(),
                    );
                  },
                ),
                GroupWidget(
                  groupName: IWLData[1]["groups"][1]["group_name"],
                  sub: IWLData[1]["stage_name"],
                ),
                StandingsTopWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: IWLData[1]["groups"][1]["points_table"].length,
                  itemBuilder: (context, index) {
                    return StandingWidget(
                      name: IWLData[1]["groups"][1]["points_table"][index]
                          ["team_name"],
                      logo: IWLData[1]["groups"][1]["points_table"][index]
                          ["team_logo"],
                      played: IWLData[1]["groups"][1]["points_table"][index]
                              ["played"]
                          .toString(),
                      won: IWLData[1]["groups"][1]["points_table"][index]["won"]
                          .toString(),
                      draw: IWLData[1]["groups"][1]["points_table"][index]
                              ["draw"]
                          .toString(),
                      lost: IWLData[1]["groups"][1]["points_table"][index]
                              ["lost"]
                          .toString(),
                      points: IWLData[1]["groups"][1]["points_table"][index]
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
