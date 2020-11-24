import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Animations/shimmer.dart';
import 'package:transfer_news/Helper/gnews_helper.dart';
import 'package:transfer_news/Model/tmnewsmodel.dart';
import 'package:transfer_news/Pages/bodyWebView/webview.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews>
    with AutomaticKeepAliveClientMixin<AllNews> {
  bool _loading = true;
  List<GNewsAll> gnews = new List<GNewsAll>();

  void initState() {
    getGNews();
    print(DateTime.now());
    super.initState();
  }

  getGNews() async {
    GoogleNewsList googleNewsListClass = GoogleNewsList();
    await googleNewsListClass.getLatestGNews();
    gnews = googleNewsListClass.allGNews;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading == true
        ? ShimmerList()
        : ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: gnews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    pushNewScreen(
                      context,
                      withNavBar: false,
                      customPageRoute: MorpheusPageRoute(
                        builder: (context) => WebviewScaffold(
                          url: "https://news.google.com${gnews[index].link}",
                          appBar: AppBar(
                            backgroundColor: Color(0xFF0e0e10),
                            title: Text(gnews[index].headlines),
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
                  child: Card(
                    color: Color(0xFF0e0e10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gnews[index].date,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 11,
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      gnews[index].headlines,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      gnews[index].desc,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Octicons.link,
                                          size: 18,
                                          color: Colors.grey[300],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          gnews[index].source,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            color: Colors.grey[300],
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
                              imageUrl: gnews[index].image,
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
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
