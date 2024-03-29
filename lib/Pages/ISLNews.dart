import 'dart:async';
import 'dart:convert';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transfer_news/Animations/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/LiveScore/live.dart';
import 'package:transfer_news/Repo/Widgets.dart';
import 'package:transfer_news/Widgets/NTBlocWidget.dart';
import 'package:transfer_news/Widgets/NewsCardWidget.dart';
import 'package:transfer_news/Widgets/storiesWidget.dart';

class ISLNews extends StatefulWidget {
  final FirebaseUserModel gCurrentUser;

  const ISLNews({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _ISLNewsState createState() => _ISLNewsState();
}

class _ISLNewsState extends State<ISLNews>
    with AutomaticKeepAliveClientMixin<ISLNews> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List ISLnewsData;
  List NatnewsData = [];
  int limit = 10;
  Future<String> getISLNews() async {
    var response = await http.get(
      "https://iftwc.com/wp-json/wp/v2/posts?categories=101&per_page=$limit",
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

  Future<String> getNatNews() async {
    var response = await http.get(
      "https://iftwc.com/wp-json/wp/v2/posts?categories=133",
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(
        utf8.decode(response.bodyBytes),
      );
      setState(() {
        NatnewsData = jsonResponse;
      });
    } else {
      print(response.statusCode);
    }
  }

  bool _loading;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    getNatNews();
    getISLNews();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          return null;
        } else {
          setState(() {
            _loading = true;
            limit += 10;
            getISLNews();
            Future.delayed(
              Duration(
                seconds: 5,
              ),
            ).whenComplete(() {
              _loading = false;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ISLnewsData == null
        ? const ShimmerList()
        : SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                DelayedDisplay(
                  slidingBeginOffset: const Offset(0, -1),
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 200),
                  child: const Stories(),
                ),
                DelayedDisplay(
                  slidingBeginOffset: Offset(1, 0),
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 200),
                  child: const LiveScoreWidget(
                    leagueId: 9478, //165,
                    //9478
                  ),
                ),
                Provider.of<HomeWidgets>(context).topStories(),
                DelayedDisplay(
                  slidingBeginOffset: Offset(-1, 0),
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 300),
                  child: NationalTeamBloc(
                    natNews: NatnewsData,
                  ),
                ),
                Provider.of<HomeWidgets>(context).topISL(),
                DelayedDisplay(
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingCurve: Curves.decelerate,
                  delay: const Duration(milliseconds: 300),
                  child: ISLNewsWidget(ISLnewsData: ISLnewsData),
                ),
                _loading == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                          child: Theme(
                            data: ThemeData(
                              cupertinoOverrideTheme: CupertinoThemeData(
                                  brightness: Brightness.dark),
                            ),
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
