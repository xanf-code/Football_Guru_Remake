import 'package:flutter/material.dart';
import 'package:transfer_news/Widgets/ISLFixtureCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Fixture extends StatefulWidget {
  final String type;

  const Fixture({Key key, this.type}) : super(key: key);
  @override
  _FixtureState createState() => _FixtureState();
}

class _FixtureState extends State<Fixture>
    with AutomaticKeepAliveClientMixin<Fixture> {
  List allFixtures;

  Future<String> getAllFixtures() async {
    var response = await http.get(
      "https://www.indiansuperleague.com/feeds-schedule/?methodtype=3&client=8&sport=2&league=india_sl&timezone=0530&language=en&tournament=india_sl_2020",
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        allFixtures = jsonresponse["matches"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAllFixtures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return allFixtures == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: FutureBuilder(
              future: getAllFixtures(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: allFixtures.length,
                  itemBuilder: (context, index) {
                    return allFixtures[index]["event_stage"] == widget.type
                        ? ISLFixtureCards(
                            date: allFixtures[index]["event_name"],
                            eventVenue: allFixtures[index]["venue_name"],
                            team1Name: allFixtures[index]["participants"][0]
                                ["name"],
                            team1Logo: allFixtures[index]["participants"][0]
                                ["id"],
                            team1Score: allFixtures[index]["participants"][0]
                                ["value"],
                            team2Name: allFixtures[index]["participants"][1]
                                ["name"],
                            team2Logo: allFixtures[index]["participants"][1]
                                ["id"],
                            team2Score: allFixtures[index]["participants"][1]
                                ["value"],
                          )
                        : SizedBox();
                  },
                );
              },
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
