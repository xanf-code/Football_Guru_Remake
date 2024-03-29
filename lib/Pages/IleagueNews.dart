import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Animations/shimmer.dart';
import 'package:transfer_news/Pages/LiveScore/live.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ILeagueNews extends StatefulWidget {
  const ILeagueNews();
  @override
  _ILeagueNewsState createState() => _ILeagueNewsState();
}

class _ILeagueNewsState extends State<ILeagueNews>
    with AutomaticKeepAliveClientMixin<ILeagueNews> {
  List ILeaguenewsData;

  Future<String> getISLNews() async {
    var response = await http.get(
      "https://iftwc.com/wp-json/wp/v2/posts?categories=95",
    );
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ILeaguenewsData = jsonresponse;
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
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      body: ILeaguenewsData == null
          ? const ShimmerList()
          : ILeagueNewsWidget(ILeaguenewsData: ILeaguenewsData),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ILeagueNewsWidget extends StatelessWidget {
  const ILeagueNewsWidget({
    Key key,
    this.ILeaguenewsData,
  }) : super(key: key);

  final List ILeaguenewsData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DelayedDisplay(
            fadingDuration: const Duration(milliseconds: 800),
            slidingCurve: Curves.decelerate,
            delay: const Duration(milliseconds: 200),
            child: const LiveScoreWidget(
              leagueId: 8982,
            ),
          ),
          DelayedDisplay(
            fadingDuration: const Duration(milliseconds: 800),
            slidingCurve: Curves.decelerate,
            delay: const Duration(milliseconds: 300),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ILeaguenewsData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    pushNewScreen(
                      context,
                      withNavBar: false,
                      customPageRoute: MorpheusPageRoute(
                        builder: (context) => WebviewScaffold(
                          url: ILeaguenewsData[index]["link"],
                          appBar: AppBar(
                            backgroundColor: appBG,
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Share.share(
                                    "${parse(ILeaguenewsData[index]["title"]["rendered"]).documentElement.text}"
                                    " "
                                    "${ILeaguenewsData[index]["link"]}",
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Ionicons.ios_share_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  launch(
                                    ILeaguenewsData[index]["link"],
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Ionicons.ios_globe,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          hidden: true,
                          initialChild: Container(
                            color: appBG,
                            child: Center(
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        transitionDuration: const Duration(
                          milliseconds: 200,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        height: 280,
                        width: MediaQuery.of(context).size.width,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          fit: BoxFit.cover,
                          image: ILeaguenewsData[index]
                                      ["jetpack_featured_media_url"] ==
                                  ""
                              ? "https://www.globalpharmatek.com/wp-content/uploads/2016/10/orionthemes-placeholder-image.jpg"
                              : ILeaguenewsData[index]
                                  ["jetpack_featured_media_url"],
                        ),
                      ),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Container(
                        height: 280,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      Positioned(
                        bottom: 25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                bottom: 12,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4,
                                    left: 6,
                                    right: 6,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ILeaguenewsData[index]["custom"]
                                              ["categories"][0]["name"]
                                          .toString()
                                          .toUpperCase(),
                                      style: GoogleFonts.rubik(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Html(
                              padding: EdgeInsets.only(
                                right: 16,
                                left: 16,
                              ),
                              data: ILeaguenewsData[index]["title"]["rendered"],
                              defaultTextStyle: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 18.0,
                                    top: 8,
                                  ),
                                  child: Text(
                                    ILeaguenewsData[index]["custom"]["author"]
                                        ["name"],
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    top: 10,
                                  ),
                                  child: Text(
                                    Jiffy(
                                      ILeaguenewsData[index]["date"],
                                      "yyyy-MM-dd",
                                    ).fromNow(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 8,
                        child: IconButton(
                          splashRadius: 1,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Share.share(
                              "${parse(ILeaguenewsData[index]["title"]["rendered"]).documentElement.text}"
                              " "
                              "${ILeaguenewsData[index]["link"]}",
                            );
                          },
                          icon: Unicon(
                            UniconData.uniShare,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
