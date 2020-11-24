import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transfer_news/Pages/constants/constants.dart';

class ILeagueAssists extends StatefulWidget {
  final int data1;
  final int data2;

  const ILeagueAssists({Key key, this.data1, this.data2}) : super(key: key);
  @override
  _ILeagueAssistsState createState() => _ILeagueAssistsState();
}

class _ILeagueAssistsState extends State<ILeagueAssists>
    with AutomaticKeepAliveClientMixin<ILeagueAssists> {
  List ILeagueStats;

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

  Future<String> getILeagueStats() async {
    var response = await http.get(
        "https://site.web.api.espn.com/apis/site/v2/sports/soccer/IND.2/statistics?region=in&lang=en&contentorigin=espn&scoring=true",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ILeagueStats = jsonresponse["stats"][1]["leaders"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getILeagueStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ILeagueStats == null
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[800],
              endIndent: 30,
              indent: 30,
            ),
            physics: ClampingScrollPhysics(),
            itemCount: ILeagueStats.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                    "https://i.ibb.co/gwcs9W3/blankface.png",
                  ),
                ),
                title: Text(
                  ILeagueStats[index]["athlete"]["displayName"],
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
                        imageUrl: ILeagueStats[index]["athlete"]["team"]
                                    ["logos"] ==
                                null
                            ? "https://upload.wikimedia.org/wikipedia/en/thumb/7/7d/Official_Churchill_Brothers_FC_Goa_Logo.png/250px-Official_Churchill_Brothers_FC_Goa_Logo.png"
                            : ILeagueStats[index]["athlete"]["team"]["logos"][0]
                                ["href"],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ILeagueStats[index]["athlete"]["team"]["displayName"],
                        style: GoogleFonts.rubik(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
//                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        ILeagueStats[index]["athlete"]["statistics"][0]
                            ["displayValue"],
                        style: GoogleFonts.ubuntu(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        ILeagueStats[index]["athlete"]["statistics"][2]
                            ["displayValue"],
                        style: GoogleFonts.ubuntu(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
