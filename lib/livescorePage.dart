import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LiveScores extends StatefulWidget {
  @override
  _LiveScoresState createState() => _LiveScoresState();
}

class _LiveScoresState extends State<LiveScores> {
  String urlPath = "https://www.fotmob.com/matches/";
  List LiveScores;

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

  Future<String> getLiveScores() async {
    var response = await http.get(urlPath, headers: headers);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        LiveScores = jsonresponse["leagues"];
      });
    } else {
      print(response.statusCode);
    }
  }

  Timer timer;

  @override
  void initState() {
    getLiveScores();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getLiveScores());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: LiveScores.length,
        itemBuilder: (context, index) {
          final scores = LiveScores[index]["matches"];
          return LiveScores[index]["primaryId"] == 9478
              ? Column(
                  children: [
                    for (final l in scores)
                      Text(
                        l["id"].toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                        ),
                      ),
                  ],
                )
              : SizedBox();
        },
      ),
    );
  }
}
