import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
        stream: context.watch<Repository>().getForum(widget.forumName, _limit),
        builder: (context, AsyncSnapshot snapshot) {
          print("building");
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: AnimationLimiter(
                child: ListView.builder(
                  cacheExtent: 500.0,
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot posts = snapshot.data.docs[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: snapshot.data.docs.length,
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: PostContainer(
                            post: posts,
                            route: widget.forumName,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
