import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoachesLineUp extends StatefulWidget {
  final int matchID;

  final int teamIndex;

  const CoachesLineUp({Key key, this.matchID, this.teamIndex})
      : super(key: key);
  @override
  _CoachesLineUpState createState() => _CoachesLineUpState();
}

class _CoachesLineUpState extends State<CoachesLineUp>
    with AutomaticKeepAliveClientMixin<CoachesLineUp> {
  List CoachLineup;

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

  Future<String> getLineups() async {
    var response = await http.get(
        "https://www.fotmob.com/matchDetails?matchId=${widget.matchID}",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        CoachLineup = jsonresponse["content"]["lineup"]["lineup"];
        //print(PlayerLineUp);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getLineups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoachLineup == null
        ? Center(
            child: SizedBox(),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: CoachLineup[widget.teamIndex]["coach"] == null
                          ? ""
                          : CoachLineup[widget.teamIndex]["coach"][0]
                              ["imageUrl"],
                      placeholder: (context, url) => new CachedNetworkImage(
                        fit: BoxFit.cover,
                        color: Colors.grey,
                        imageUrl:
                            "https://list.wiki/images/9/92/Unknown-avatar.png",
                      ),
                    ),
                  ),
                ),
                title: Text(
                  CoachLineup[widget.teamIndex]["coach"] == null
                      ? ""
                      : CoachLineup[widget.teamIndex]["coach"][0]["name"],
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  CoachLineup[widget.teamIndex]["coach"] == null
                      ? ""
                      : CoachLineup[widget.teamIndex]["coach"][0]["role"]
                          .toString(),
                  style: GoogleFonts.rubik(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
