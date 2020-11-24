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
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[800],
                    endIndent: 30,
                    indent: 30,
                  ),
                  physics: ClampingScrollPhysics(),
                  itemCount: ISLStats.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          "https://images.fotmob.com/image_resources/playerimages/${ISLStats[index]["ParticiantId"]}.png",
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
                              widget.type == "rating"
                                  ? ISLStats[index]["StatValue"]
                                      .toString()
                                      .substring(0, 3)
                                  : ISLStats[index]["StatValue"].toString(),
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
              },
            ),
          );
  }
  // Card(
  // elevation: 0,
  // color: Colors.transparent,
  // child: Padding(
  // padding: const EdgeInsets.all(25.0),
  // child: Row(
  // children: [
  // Expanded(
  // child: Row(
  // mainAxisAlignment:
  // MainAxisAlignment.spaceBetween,
  // children: [
  // Container(
  // child: CachedNetworkImage(
  // height: 30,
  // width: 30,
  // imageUrl:
  // "https://www.sofascore.com/images/player/image_${ISLStats[index]["player"]["id"]}.png",
  // ),
  // ),
  // Container(
  // child: Text(
  // ISLStats[index]["player"]
  // ["shortName"],
  // style: GoogleFonts.rubik(
  // color: Colors.white,
  // fontWeight: FontWeight.w500,
  // fontSize: 17,
  // ),
  // ),
  // ),
  // // SizedBox(
  // //   width: 30,
  // // ),
  //
  // Container(
  // margin: EdgeInsets.only(left: 20),
  // child: _buildChild(index),
  // ),
  // Container(
  // margin: EdgeInsets.only(left: 45),
  // child: Text(
  // ISLStats[index]["statistics"]
  // ["appearances"]
  //     .toString(),
  // style: GoogleFonts.ubuntu(
  // color: Colors.white70,
  // fontWeight: FontWeight.bold,
  // fontSize: 15,
  // ),
  // ),
  // ),
  // Container(
  // margin: EdgeInsets.only(left: 40),
  // child: Text(
  // ISLStats[index]["statistics"]
  // [widget.attribute] ==
  // ISLStats[index]["statistics"]
  // ["rating"]
  // ? ISLStats[index]["statistics"]
  // ["rating"]
  //     .toString()
  //     .substring(0, 3)
  //     : ISLStats[index]["statistics"]
  // [widget.attribute]
  //     .toString(),
  // style: GoogleFonts.ubuntu(
  // color: Colors.white70,
  // fontWeight: FontWeight.bold,
  // fontSize: 15,
  // ),
  // ),
  // ),
  // ],
  // ),
  // ),
  // ],
  // ),
  // ),
  // );

  // Widget _buildChild(index) {
  //   if (ISLStats[index]["team"]["name"] == "Goa") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/2/22/FC_Goa_logo.svg/200px-FC_Goa_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "ATK") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://tmssl.akamaized.net/images/wappen/big/83266.png?lm=1594388158");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Bengaluru FC") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/5/52/Bengaluru_FC_logo.svg/200px-Bengaluru_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Chennaiyin FC") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/6/6c/Chennaiyin_FC_logo.svg/200px-Chennaiyin_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Mumbai City FC") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Mumbai_City_FC.svg/160px-Mumbai_City_FC.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Odisha Football Club") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/5/57/Odisha_FC_logo.svg/1200px-Odisha_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Kerala Blasters") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/Kerala_Blasters_FC_logo.svg/150px-Kerala_Blasters_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Jamshedpur") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/5/57/Jamshedpur_FC_logo.svg/200px-Jamshedpur_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Northeast United") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/NorthEast_United_FC_logo.svg/200px-NorthEast_United_FC_logo.svg.png");
  //   }
  //   if (ISLStats[index]["team"]["name"] == "Hyderabad FC") {
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://upload.wikimedia.org/wikipedia/commons/c/c3/Hderabad_FC_Official_New_Logo.png");
  //   } else
  //     return CachedNetworkImage(
  //         height: 30,
  //         width: 30,
  //         imageUrl:
  //             "https://www.pngkey.com/png/full/135-1353419_empty-crest-png-clip-blank-shield-logo-png.png");
  // }
}
