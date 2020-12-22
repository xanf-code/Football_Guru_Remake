import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:realtime_pagination/realtime_pagination.dart';
import 'package:transfer_news/Forum/RoutePage/addPost.dart';
import 'package:transfer_news/Forum/Widgets/postContainer.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Utils/constants.dart';

class ForumDetails extends StatefulWidget {
  final String forumName;
  final List<String> tagName;
  final String appBar;
  const ForumDetails({Key key, this.forumName, this.tagName, this.appBar})
      : super(key: key);
  @override
  _ForumDetailsState createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails>
    with AutomaticKeepAliveClientMixin<ForumDetails> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: appBG,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          heroTag: null,
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              MaterialCommunityIcons.fountain_pen,
              size: 30,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: FABGradient,
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MorpheusPageRoute(
                builder: (context) => AddPostToForum(
                  name: widget.forumName,
                  tags: widget.tagName.toList(),
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
        ),
      ),
      // body: StreamBuilder(
      //   stream: Provider.of<Repository>(
      //     context,
      //   ).getForum(widget.forumName, _limit),
      //   builder: (context, AsyncSnapshot snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: const CircularProgressIndicator(),
      //       );
      //     } else {
      //       return Scrollbar(
      //         controller: ScrollController(),
      //         thickness: 3,
      //         radius: Radius.circular(10),
      //         child: AnimationLimiter(
      //           child: ListView.builder(
      //             cacheExtent: 500.0,
      //             controller: _scrollController,
      //             itemCount: snapshot.data.docs.length,
      //             itemBuilder: (context, index) {
      //               final DocumentSnapshot posts = snapshot.data.docs[index];
      //               return AnimationConfiguration.staggeredGrid(
      //                 position: index,
      //                 duration: const Duration(milliseconds: 500),
      //                 columnCount: snapshot.data.docs.length,
      //                 child: SlideAnimation(
      //                   verticalOffset: 50,
      //                   child: FadeInAnimation(
      //                     child: PostContainer(
      //                       post: posts,
      //                       route: widget.forumName,
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // ),
      body: Scrollbar(
        controller: ScrollController(),
        thickness: 3,
        radius: Radius.circular(10),
        child: RealtimePagination(
            query: Provider.of<Repository>(
              context,
            ).getForum(widget.forumName),
            itemsPerPage: 10,
            itemBuilder: (index, context, docSnapshot) {
              final DocumentSnapshot posts = docSnapshot;
              return PostContainer(
                post: posts,
                route: widget.forumName,
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
