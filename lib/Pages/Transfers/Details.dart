import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferDetails extends StatelessWidget {
  final String name;
  final String playerImage;
  final String playername;
  final String playerProfile;
  final String date;
  final String fromTeamImage;
  final String toTeamImage;
  final String fromTeam;
  final String toTeam;
  final String fee;

  const TransferDetails(
      {Key key,
      this.name,
      this.playerImage,
      this.playername,
      this.playerProfile,
      this.date,
      this.fromTeamImage,
      this.toTeamImage,
      this.fromTeam,
      this.toTeam,
      this.fee})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF0e0e10),
        centerTitle: false,
        title: Text(
          this.name,
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[900].withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xFF7232f2),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  this.playerImage,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              this.playername,
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          this.date,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: this.fromTeamImage,
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
                          imageUrl: this.toTeamImage,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        this.fromTeam,
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
                        this.toTeam,
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
                          this.fee.toUpperCase(),
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
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 12),
            child: Text(
              "Links",
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFF7232f2),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            CachedNetworkImageProvider(this.playerImage),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      this.playername,
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    launch("https://www.transfermarkt.co.in${playerProfile}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1e1e1e),
                      ),
                      child: Center(
                        child: Icon(
                          Ionicons.ios_link,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
