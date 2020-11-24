import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:html/parser.dart';

class ISLNewsWidget extends StatelessWidget {
  const ISLNewsWidget({
    Key key,
    @required this.ISLnewsData,
  }) : super(key: key);

  final List ISLnewsData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, _) {
        return Divider(
          color: Colors.grey[800],
          indent: 20,
          endIndent: 20,
        );
      },
      itemCount: ISLnewsData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => WebviewScaffold(
                  url: ISLnewsData[index]["link"],
                  appBar: AppBar(
                    backgroundColor: Color(0xFF0e0e10),
                    title: Text(
                      parse(ISLnewsData[index]["title"]["rendered"])
                          .documentElement
                          .text,
                    ),
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
                            ISLnewsData[index]["jetpack_featured_media_url"] ==
                                    ""
                                ? "https://www.globalpharmatek.com/wp-content/uploads/2016/10/orionthemes-placeholder-image.jpg"
                                : ISLnewsData[index]
                                    ["jetpack_featured_media_url"],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: Html(
                      data: ISLnewsData[index]["title"]["rendered"],
                      defaultTextStyle: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 12, top: 8, bottom: 8),
                        child: Text(
                          Jiffy(
                            ISLnewsData[index]["date"],
                            "yyyy-MM-dd",
                          ).fromNow(),
                          style: GoogleFonts.rubik(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 18.0,
                          //right: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          ISLnewsData[index]["custom"]["author"]["name"],
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
            ],
          ),
        );
      },
    );
  }
}
