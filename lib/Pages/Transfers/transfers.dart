import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Helper/transfer_helper.dart';
import 'package:transfer_news/Model/transfer.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/Transfers/Details.dart';
import 'package:transfer_news/Pages/home.dart';

class AllTransfers extends StatefulWidget {
  final User gCurrentUser;

  const AllTransfers({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _AllTransfersState createState() => _AllTransfersState();
}

class _AllTransfersState extends State<AllTransfers> {
  @override
  bool _loading = true;
  List<TransferModel> transfers = new List<TransferModel>();

  void initState() {
    getTransfers();
    super.initState();
  }

  getTransfers() async {
    TransferList transferListClass = TransferList();
    await transferListClass.getLatestTransfers();
    transfers = transferListClass.allTransfers;
    setState(() {
      _loading = false;
    });
  }

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
          'Transfers',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: _loading == true
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    width: 170,
                    height: 170,
                    imageUrl:
                        "https://cdn.dribbble.com/users/282923/screenshots/11050247/paymentsbilling.gif",
                  ),
                  Positioned(
                    bottom: 20,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.blueAccent,
                      child: Text(
                        'Confirming Deals 🔥',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : AnimationLimiter(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: transfers.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: transfers.length,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            pushNewScreen(
                              context,
                              withNavBar: false,
                              customPageRoute: MorpheusPageRoute(
                                builder: (context) => TransferDetails(
                                  name: transfers[index].name,
                                  playername: transfers[index].name,
                                  playerImage: transfers[index].playerImage,
                                  playerProfile: transfers[index].playerLink,
                                  date: transfers[index].date,
                                  fromTeam: transfers[index].fromTeam,
                                  fromTeamImage: transfers[index].fromTeamImage,
                                  toTeam: transfers[index].toTeam,
                                  toTeamImage: transfers[index].toTeamImage,
                                  fee: transfers[index].fee,
                                ),
                                transitionDuration: Duration(
                                  milliseconds: 200,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4, bottom: 6),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xFF0e0e10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 23,
                                              backgroundColor:
                                                  Color(0xFF7232f2),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                  (transfers[index]
                                                      .playerImage),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              transfers[index].name,
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          transfers[index].date,
                                          style: GoogleFonts.ubuntu(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                      top: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              transfers[index].fromTeamImage,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Ionicons.md_arrow_dropright,
                                          color: Colors.white,
                                          size: 21,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              transfers[index].toTeamImage,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        transfers[index].fromTeam,
                                        style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Ionicons.ios_airplane,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        transfers[index].toTeam,
                                        style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xFF1e1e1e),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          transfers[index].fee.toUpperCase(),
                                          style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
