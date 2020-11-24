import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Model/tmnewsmodel.dart';
import 'package:transfer_news/Pages/bodyWebView/webview.dart';
import 'package:transfer_news/Pages/home.dart';

class TMNewsWidget extends StatelessWidget {
  const TMNewsWidget({
    Key key,
    @required this.news,
  }) : super(key: key);

  final List<TMNewsModel> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: news.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              pushNewScreen(
                context,
                withNavBar: false,
                customPageRoute: MorpheusPageRoute(
                  builder: (context) => WebviewScaffold(
                    url:
                        "https://www.transfermarkt.co.in${news[index].articleLink}",
                    appBar: AppBar(
                      backgroundColor: Color(0xFF0e0e10),
                      title: Text(news[index].headline),
                    ),
                    hidden: true,
                    initialChild: Container(
                      color: Color(0xFF0e0e10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  transitionDuration: Duration(
                    milliseconds: 200,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Color(0xFF0e0e10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Jiffy("${news[index].DateTime.replaceAll(".", "-")}",
                                          "dd-MM-yyyy")
                                      .fromNow(),
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 11,
                                    color: Colors.grey[300],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  news[index].headline,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: news[index].topImage,
                                      height: 22,
                                      width: 22,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      news[index].subline,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: news[index].articleImage,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
