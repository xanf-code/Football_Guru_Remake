import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Pages/LeaguePages/OnTapCallbackPage/IWLCallBack.dart';

class StatsWidget extends StatefulWidget {
  final String url;

  const StatsWidget({Key key, this.url}) : super(key: key);
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget>
    with AutomaticKeepAliveClientMixin<StatsWidget> {
  List allStats;

  Future<String> getAllStats() async {
    var response = await http.get(
      widget.url,
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        allStats = jsonresponse["top_scorers"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return allStats == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  bottom: 10,
                  top: 10,
                ),
                child: Text(
                  "Goals",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ListView.separated(
                separatorBuilder: (context, _) {
                  return Divider(
                    color: Colors.grey[800],
                    indent: 20,
                    endIndent: 20,
                  );
                },
                shrinkWrap: true,
                itemCount: allStats.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
                          allStats[index]["photo"],
                        ),
                      ),
                      title: Text(
                        allStats[index]["player_name"],
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              height: 20,
                              width: 20,
                              imageUrl: allStats[index]["logo"] ==
                                      "https://administrator.the-aiff.com/"
                                  ? "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png"
                                  : allStats[index]["logo"],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              allStats[index]["team_name"] ==
                                      "Kangchup Road Young Physical & Sports Association-KRYHPSA"
                                  ? "KRYHPSA"
                                  : allStats[index]["team_name"],
                              style: GoogleFonts.rubik(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          allStats[index]["total_goals"].toString(),
                          style: GoogleFonts.ubuntu(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
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
