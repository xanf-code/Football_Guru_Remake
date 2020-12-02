import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/Featured/comments.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;
  final String postUrl;
  final String postTag;
  CommentsPage(
      {this.postId,
      this.postOwnerId,
      this.postDescription,
      this.postType,
      this.postUrl,
      this.postTag});

  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId,
      postOwnerId: postOwnerId,
      postDescription: postDescription,
      postType: postType,
      postUrl: postUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;
  final String postUrl;

  CommentsPageState(
      {Key key,
      this.postId,
      this.postUrl,
      this.postOwnerId,
      this.postDescription,
      this.postType});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              stretch: true,
              backgroundColor: Color(0xFF0e0e10),
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.postUrl,
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.postType,
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    widget.postTag == " "
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              top: 2,
                              bottom: 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                //width: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7232f2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4,
                                    left: 6,
                                    right: 6,
                                  ),
                                  child: Text(
                                    widget.postTag,
                                    style: GoogleFonts.averageSans(
                                      fontSize: 12,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Divider(
                      color: Colors.grey[700],
                      indent: 10,
                      endIndent: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Html(
                        data: widget.postDescription,
                        defaultTextStyle: GoogleFonts.rubik(
                          color: Colors.grey[400],
                          fontSize: 16,
                          //fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
        floatingActionButton: AvatarGlow(
          endRadius: 40,
          glowColor: Colors.yellow,
          child: FloatingActionButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              pushNewScreen(
                context,
                withNavBar: false,
                customPageRoute: MorpheusPageRoute(
                  builder: (context) => FeaturedComments(
                    postId: widget.postId,
                  ),
                  transitionDuration: Duration(
                    milliseconds: 200,
                  ),
                ),
              );
            },
            backgroundColor: Color(0xFF7232f2),
            child: Icon(
              MaterialCommunityIcons.comment_text_multiple_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
