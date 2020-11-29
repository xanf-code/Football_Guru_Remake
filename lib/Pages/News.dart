import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_unicons/model.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transfer_news/Helper/tmnews_helper.dart';
import 'package:transfer_news/Model/tmnewsmodel.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/ISLNews.dart';
import 'package:transfer_news/Pages/IleagueNews.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/categoryPages/categoryIntroPage.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/PlayerPoll/playervotes.dart';
import 'package:transfer_news/Reels(Beta)/AddReelPage.dart';
import 'package:transfer_news/Youtube/youtube.dart';
import 'package:transfer_news/chatForum/chatIntro.dart';
import 'package:transfer_news/chatForum/chatPage.dart';
import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';
import 'package:transfer_news/main.dart';

import 'NestedPages/TransferNewsPage.dart';

class NewsPage extends StatefulWidget {
  final User gCurrentUser;

  const NewsPage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  bool _loading = true;
  List<TMNewsModel> news = new List<TMNewsModel>();
  Box<Favourites> favBox;

  void initState() {
    getNews();
    favBox = Hive.box<Favourites>(boxName);
    super.initState();
  }

  getNews() async {
    NewsList newsListClass = NewsList();
    await newsListClass.getLatestNews();
    news = newsListClass.allNews;
    setState(() {
      _loading = false;
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //leading: Container(),
          actions: [
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 40,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    customPageRoute: MorpheusPageRoute(
                      builder: (context) => ProfilePage(
                        userProfileId: currentUser.id,
                      ),
                      transitionDuration: Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.gCurrentUser.url),
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Color(0xFF0e0e10),
          centerTitle: false,
          title: Text(
            'News',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Container(
              padding: EdgeInsets.only(
                right: 12,
                left: 4,
                bottom: 12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelStyle: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[900],
                  ),
                  tabs: <Widget>[
                    Tab(
                      text: "ISL News",
                    ),
                    Tab(
                      text: "I-League News",
                    ),
                    Tab(
                      text: "Transfer News",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ISLNews(
              gCurrentUser: currentUser,
            ),
            ILeagueNews(),
            TMNewsWidget(news: news),
          ],
        ),
        drawer: SafeArea(
          child: Container(
            width: 70,
            child: Drawer(
              elevation: 0,
              child: Container(
                color: Color(0xFF0e0e10),
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => ChatIntro(),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniChatInfo,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MorpheusPageRoute(
                            transitionDuration: Duration(milliseconds: 200),
                            builder: (context) => CategoryPage(),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniNewspaper,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => Reels(),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniVideo,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => PlayerVotes(),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniArrowUp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => techtroYoutube(),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniYoutubeMonochrome,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MorpheusPageRoute(
                            transitionDuration: Duration(milliseconds: 200),
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: DiscordType(
                        height: 50,
                        width: 50,
                        color: Colors.blueGrey[900],
                        icons: UniconData.uniSetting,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: favBox.listenable(),
                      builder: (context, Box<Favourites> favs, _) {
                        List<int> keys = favs.keys.cast<int>().toList();
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final int key = keys[index];
                            final Favourites boxfavs = favs.get(key);
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context);
                                pushNewScreen(
                                  context,
                                  withNavBar: false,
                                  customPageRoute: MorpheusPageRoute(
                                    builder: (context) => ChatPage(
                                      reference: boxfavs.ref,
                                      title: boxfavs.appTitle,
                                      Image: boxfavs.logo,
                                      chatScreenContext: context,
                                    ),
                                    transitionDuration: Duration(
                                      milliseconds: 200,
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                HapticFeedback.mediumImpact();
                                favBox.delete(key);
                              },
                              child: ChatType(
                                height: 50,
                                width: 50,
                                color: Colors.blueGrey[900],
                                url: boxfavs.logo,
                              ),
                            );
                          },
                          itemCount: keys.length,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscordType extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final UniconDataModel icons;
  const DiscordType({
    Key key,
    this.height,
    this.width,
    this.color,
    this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Unicon(
            icons,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChatType extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String url;
  const ChatType({
    Key key,
    this.height,
    this.width,
    this.color,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 8,
            child: Icon(
              Ionicons.ios_heart,
              color: Colors.red,
              size: 10,
            ),
          ),
        ],
      ),
    );
  }
}
