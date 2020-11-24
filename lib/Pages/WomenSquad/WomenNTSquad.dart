import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WomenNTSquad extends StatefulWidget {
  @override
  _WomenNTSquadState createState() => _WomenNTSquadState();
}

class _WomenNTSquadState extends State<WomenNTSquad>
    with AutomaticKeepAliveClientMixin<WomenNTSquad> {
  List womenSquad;

  Future<String> getSquad() async {
    var response = await http.get(
      "https://www.the-aiff.com/api/national-team/squad/2/30",
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        womenSquad = jsonresponse["players"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getSquad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return womenSquad == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: womenSquad.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(
                      womenSquad[index]["photo_thumb"],
                    ),
                  ),
                  title: Text(
                    womenSquad[index]["player_name"],
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    womenSquad[index]["position_name"],
                    style: GoogleFonts.rubik(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
