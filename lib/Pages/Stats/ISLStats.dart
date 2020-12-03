import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transfer_news/Widgets/squadWidget.dart';

class ISLStats extends StatefulWidget {
  final String type;
  final String attribute;
  const ISLStats({
    Key key,
    this.type,
    this.attribute,
  }) : super(key: key);
  @override
  _ISLStatsState createState() => _ISLStatsState();
}

class _ISLStatsState extends State<ISLStats> {
  List ISLStats;

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

  Future<String> getISLStats() async {
    var response = await http.get(
        "https://data.fotmob.com/stats/9478/${widget.type}.json.gz",
        headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ISLStats = jsonresponse["TopLists"][0]["StatList"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getISLStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ISLStats == null
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: FutureBuilder(
              future: getISLStats(),
              builder: (context, snapshot) {
                return Scrollbar(
                  thickness: 3,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: ISLStats.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: Colors.black87,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://images.fotmob.com/image_resources/playerimages/${ISLStats[index]["ParticiantId"]}.png",
                                placeholder: (context, url) =>
                                    new CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  color: Colors.grey,
                                  imageUrl:
                                      "https://list.wiki/images/9/92/Unknown-avatar.png",
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            ISLStats[index]["ParticipantName"],
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
                                  imageUrl:
                                      "https://www.fotmob.com/images/team/${ISLStats[index]["TeamId"]}_small",
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ISLStats[index]["TeamName"],
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
                                  ISLStats[index]["MatchesPlayed"].toString(),
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  widget.type == "rating"
                                      ? ISLStats[index]["StatValue"]
                                          .toString()
                                          .substring(0, 3)
                                      : ISLStats[index]["StatValue"]
                                          .toInt()
                                          .toString(),
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
  }
}
