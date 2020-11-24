import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/LeaguePages/Page1_NT.dart';
import 'package:transfer_news/Pages/LeaguePages/Page2_Leagues.dart';
import 'package:transfer_news/Pages/LeaguePages/Page_3_Women.dart';
import 'package:transfer_news/Pages/LeaguePages/Page_4_AFC.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/home.dart';

class Standings extends StatefulWidget {
  final User gCurrentUser;

  const Standings({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  int selectedIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
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
          'Leagues',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 45,
                      unselectedLabelTextStyle: GoogleFonts.rubik(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                      selectedLabelTextStyle: GoogleFonts.rubik(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: Color(0xFF0e0e10),
                      groupAlignment: -1,
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (newIndex) {
                        HapticFeedback.mediumImpact();
                        selectedIndex = newIndex;
                        setState(() {
                          selectedIndex = newIndex;
                          pageController.animateToPage(
                            newIndex,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      destinations: [
                        NavigationRailDestination(
                          icon: SizedBox.shrink(),
                          label: RotatedBox(
                            quarterTurns: -1,
                            child: Text("National Team"),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: SizedBox.shrink(),
                          label: RotatedBox(
                            quarterTurns: -1,
                            child: Text("National Leagues"),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: SizedBox.shrink(),
                          label: RotatedBox(
                            quarterTurns: -1,
                            child: Text("Women's League"),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: SizedBox.shrink(),
                          label: RotatedBox(
                            quarterTurns: -1,
                            child: Text("Continental Tournaments"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                NationalTeam(),
                LeaguePage(),
                WomensPage(),
                ContinentalTournaments(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
