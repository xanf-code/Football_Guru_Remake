import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCardWidget extends StatefulWidget {
  final String url;

  const NewsCardWidget({Key key, this.url}) : super(key: key);
  @override
  _NewsCardWidgetState createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget>
    with AutomaticKeepAliveClientMixin<NewsCardWidget> {
  List newsData;

  Future<String> getAllNews() async {
    var response = await http.get(widget.url);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        newsData = jsonresponse["news"]["dataset"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAllNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return newsData == null || newsData.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: newsData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => WebviewScaffold(
                        url: newsData[index]["page"]["url"],
                        appBar: AppBar(
                          backgroundColor: appBG,
                          actions: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Share.share(
                                  "${parse(newsData[index]["title"]).documentElement.text}"
                                  " "
                                  "${newsData[index]["page"]["url"]}",
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
                                  newsData[index]["page"]["url"],
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  newsData[index]["imageUrl"],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8),
                          child: Text(
                            newsData[index]["title"],
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 12, top: 8, bottom: 8),
                          child: Text(
                            newsData[index]["sourceStr"],
                            style: GoogleFonts.rubik(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
