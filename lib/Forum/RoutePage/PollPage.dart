import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:realtime_pagination/realtime_pagination.dart';
import 'package:transfer_news/Forum/RoutePage/addPoll.dart';
import 'package:transfer_news/Forum/Widgets/PollContainer.dart';
import 'package:transfer_news/Repo/repo.dart';
import 'package:transfer_news/Utils/constants.dart';

class PollPage extends StatefulWidget {
  final String route;

  const PollPage({Key key, this.route}) : super(key: key);
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage>
    with AutomaticKeepAliveClientMixin<PollPage> {
  @override
  bool get wantKeepAlive => true;

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
              MaterialCommunityIcons.poll,
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
                builder: (context) => AddPollPage(
                  route: widget.route,
                  tags: pollTags,
                ),
                transitionDuration: Duration(
                  milliseconds: 200,
                ),
              ),
            );
          },
        ),
      ),
      body: Scrollbar(
        controller: ScrollController(),
        thickness: 3,
        radius: Radius.circular(10),
        child: RealtimePagination(
          query: Provider.of<Repository>(
            context,
          ).getPoll(widget.route),
          itemsPerPage: 10,
          itemBuilder: (index, context, docSnapshot) {
            final DocumentSnapshot polls = docSnapshot;
            return PollContainer(
              polls: polls,
              route: widget.route,
              context: context,
            ).pollBox();
          },
        ),
      ),
      // StreamBuilder(
      //   stream: Provider.of<Repository>(
      //     context,
      //   ).getPoll(widget.route),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     if (snapshot.data.docs.isEmpty) {
      //       return Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Center(
      //             child: CachedNetworkImage(
      //               imageUrl:
      //                   "https://ouch-cdn.icons8.com/preview/606/90c1f2d7-b42f-4d7e-9d17-e183179862b7.png",
      //               width: 400,
      //             ),
      //           ),
      //           Text(
      //             "Post something :<",
      //             style: TextStyle(
      //               color: Colors.grey,
      //               fontWeight: FontWeight.w500,
      //               fontSize: 20,
      //             ),
      //           ),
      //         ],
      //       );
      //     } else {
      //       return Scrollbar(
      //         controller: ScrollController(),
      //         thickness: 3,
      //         radius: Radius.circular(10),
      //         child: ListView.builder(
      //           cacheExtent: 500.0,
      //           controller: _scrollController,
      //           itemCount: snapshot.data.docs.length,
      //           itemBuilder: (context, index) {
      //             DocumentSnapshot polls = snapshot.data.docs[index];
      //             return PollContainer(
      //               polls: polls,
      //               route: widget.route,
      //               context: context,
      //             ).pollBox();
      //           },
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
