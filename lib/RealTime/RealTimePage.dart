import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/AddPostPage/addPost.dart';
import 'package:transfer_news/RealTime/Widget/RTContainer.dart';
import 'package:transfer_news/RealTime/bloc/data_bloc/data_bloc.dart';
import 'package:transfer_news/Utils/constants.dart';

class RealTimeUI extends StatefulWidget {
  final FirebaseUserModel gCurrentUser;

  const RealTimeUI({Key key, this.gCurrentUser}) : super(key: key);
  @override
  createState() => _RealTimeUIState();
}

class _RealTimeUIState extends State<RealTimeUI> {
  DataBloc _dataBloc = DataBloc();
  @override
  initState() {
    super.initState();
    _dataBloc.add(DataEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      //AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        backgroundColor: appBG,
        centerTitle: false,
        title: Text(
          'Real Time',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: currentUser.isAdmin == false
          ? SizedBox()
          : FloatingActionButton(
              child: Container(
                width: 60,
                height: 60,
                child: Icon(
                  MaterialCommunityIcons.fountain_pen,
                  size: 30,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xffF58529),
                      Color(0xffFEDA77),
                      Color(0xffDD2A7B),
                      Color(0xff8134AF),
                      Color(0xff515BD4),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                pushNewScreen(
                  context,
                  withNavBar: false,
                  customPageRoute: MorpheusPageRoute(
                    builder: (context) => AddRealTime(),
                    transitionDuration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                );
              },
            ),
      body: BlocBuilder<DataBloc, DataState>(
        cubit: _dataBloc,
        builder: (BuildContext context, DataState state) {
          if (state is DataStateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataStateEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else if (state is DataStateLoadSuccess) {
            return Scrollbar(
              thickness: 3,
              radius: Radius.circular(10),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: state.hasMoreData
                      ? state.tweets.length + 1
                      : state.tweets.length,
                  itemBuilder: (context, i) {
                    if (i >= state.tweets.length) {
                      _dataBloc.add(
                        DataEventFetchMore(),
                      );
                      return Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 30,
                        width: 30,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return AnimationConfiguration.staggeredGrid(
                      position: i,
                      duration: const Duration(milliseconds: 500),
                      columnCount: state.hasMoreData
                          ? state.tweets.length + 1
                          : state.tweets.length,
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: RTContainer(
                            image: state.tweets[i].userPic,
                            name: state.tweets[i].username,
                            tag: state.tweets[i].role,
                            time: state.tweets[i].timestamp,
                            caption: state.tweets[i].caption,
                            postImage: state.tweets[i].url,
                            isVerified: state.tweets[i].isVerified,
                            postID: state.tweets[i].postID,
                            likes: state.tweets[i].likes,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return null;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _dataBloc.close();
    super.dispose();
  }
}
