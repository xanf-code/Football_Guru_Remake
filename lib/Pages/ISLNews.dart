import 'dart:async';
import 'dart:convert';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_news/Animations/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/LiveScore/live.dart';
import 'package:transfer_news/Widgets/NewsCardWidget.dart';
import 'package:transfer_news/Widgets/storiesWidget.dart';

class ISLNews extends StatefulWidget {
  final User gCurrentUser;

  const ISLNews({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _ISLNewsState createState() => _ISLNewsState();
}

class _ISLNewsState extends State<ISLNews>
    with AutomaticKeepAliveClientMixin<ISLNews> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List ISLnewsData;

  Future<String> getISLNews() async {
    var response = await http.get(
      "https://iftwc.com/wp-json/wp/v2/posts?categories=101",
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ISLnewsData = jsonResponse;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getISLNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ISLnewsData == null
        ? const ShimmerList()
        : SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                const Stories(),
                DelayedDisplay(
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 200),
                  child: const LiveScoreWidget(
                    leagueId: 9478,
                  ),
                ),
                DelayedDisplay(
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 300),
                  child: ISLNewsWidget(ISLnewsData: ISLnewsData),
                ),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
