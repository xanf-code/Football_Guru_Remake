import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SquadWidget extends StatefulWidget {
  const SquadWidget({
    Key key,
  }) : super(key: key);

  @override
  _SquadWidgetState createState() => _SquadWidgetState();
}

class _SquadWidgetState extends State<SquadWidget> {
  String urlPath =
      "https://www.fotmob.com/teams?id=6329&tab=squad&type=team&timeZone=Asia%2FCalcutta&seo=india";
  List squad;

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

  Future<String> getSquad() async {
    var response = await http.get(urlPath, headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        squad = jsonresponse["squad"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSquad();
  }

  @override
  Widget build(BuildContext context) {
    return squad == null
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Coach",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Coach(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Goalkeepers",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              goalkeeper(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Defenders",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              defenders(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Midfielders",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              mid(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Forwards",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              forward(),
            ],
          );
  }

  ListView Coach() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: squad[0][1].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(
              "https://images.fotmob.com/image_resources/playerimages/${squad[0][1][index]["id"].toString()}.png",
            ),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            squad[0][1][index]["name"],
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              CachedNetworkImage(
                height: 20,
                width: 20,
                imageUrl:
                    "https://images.fotmob.com/image_resources/logo/teamlogo/${squad[0][1][index]["ccode"].toString().toLowerCase()}.png",
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                squad[index][0],
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView goalkeeper() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: squad[1][1].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(
                "https://images.fotmob.com/image_resources/playerimages/${squad[1][1][index]["id"].toString()}.png"),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            squad[1][1][index]["name"],
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              CachedNetworkImage(
                height: 20,
                width: 20,
                imageUrl:
                    "https://images.fotmob.com/image_resources/logo/teamlogo/${squad[1][1][index]["ccode"].toString().toLowerCase()}.png",
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                squad[1][0],
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView defenders() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: squad[2][1].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(
                "https://images.fotmob.com/image_resources/playerimages/${squad[2][1][index]["id"].toString()}.png"),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            squad[2][1][index]["name"],
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              CachedNetworkImage(
                height: 20,
                width: 20,
                imageUrl:
                    "https://images.fotmob.com/image_resources/logo/teamlogo/${squad[2][1][index]["ccode"].toString().toLowerCase()}.png",
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                squad[2][0],
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView mid() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: squad[3][1].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(
                "https://images.fotmob.com/image_resources/playerimages/${squad[3][1][index]["id"].toString()}.png"),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            squad[3][1][index]["name"],
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              CachedNetworkImage(
                height: 20,
                width: 20,
                imageUrl:
                    "https://images.fotmob.com/image_resources/logo/teamlogo/${squad[3][1][index]["ccode"].toString().toLowerCase()}.png",
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                squad[3][0],
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView forward() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: squad[4][1].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(
                "https://images.fotmob.com/image_resources/playerimages/${squad[4][1][index]["id"].toString()}.png"),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            squad[4][1][index]["name"],
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              CachedNetworkImage(
                height: 20,
                width: 20,
                imageUrl:
                    "https://images.fotmob.com/image_resources/logo/teamlogo/${squad[4][1][index]["ccode"].toString().toLowerCase()}.png",
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                squad[4][0],
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
