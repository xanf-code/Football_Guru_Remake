import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

class NationalTeamBloc extends StatelessWidget {
  final List natNews;

  const NationalTeamBloc({Key key, this.natNews}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 1.3,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: natNews.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              pushNewScreen(
                context,
                withNavBar: false,
                customPageRoute: MorpheusPageRoute(
                  builder: (context) => WebviewScaffold(
                    url: natNews[index]["link"],
                    appBar: AppBar(
                      backgroundColor: appBG,
                      actions: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Share.share(
                              "${parse(natNews[index]["title"]["rendered"]).documentElement.text}"
                              " "
                              "${natNews[index]["link"]}",
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
                              natNews[index]["link"],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    height: MediaQuery.of(context).size.width / 1.3,
                    child: ParallaxImage(
                      extent: 100,
                      image: CachedNetworkImageProvider(
                        natNews[index]["jetpack_featured_media_url"],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    bottom: 8,
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
                                          "National Team".toUpperCase(),
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
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                left: 8,
                                right: 8,
                              ),
                              child: Html(
                                data: natNews[index]["title"]["rendered"],
                                defaultTextStyle: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                bottom: 8,
                              ),
                              child: Text(
                                Jiffy(
                                  natNews[index]["date"],
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
                          "${parse(natNews[index]["title"]["rendered"]).documentElement.text}"
                          " "
                          "${natNews[index]["link"]}",
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
            ),
          );
        },
      ),
    );
  }
}
