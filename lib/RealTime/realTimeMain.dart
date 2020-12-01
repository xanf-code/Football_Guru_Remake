import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/Profile/Profile.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/RealTime/AddPostPage/addPost.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/RealTime/CommentPage.dart';
import 'package:transfer_news/RealTime/imageDetailScreen.dart';

class RealTime extends StatefulWidget {
  final User gCurrentUser;

  const RealTime({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _RealTimeState createState() => _RealTimeState();
}

class _RealTimeState extends State<RealTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
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
        backgroundColor: Color(0xFF0e0e10),
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
      //Body
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("realTimeTweets")
            .orderBy("timestamp", descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, documentSnapshot) {
          if (!documentSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey[800],
                  indent: 10,
                  endIndent: 10,
                );
              },
              shrinkWrap: true,
              itemCount: documentSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot real = documentSnapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                    top: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: ClipOval(
                              child: Image.network(
                                real.data()["userPic"],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    real.data()["name"],
                                    style: GoogleFonts.averageSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  real.data()["isVerified"] != true
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6.0,
                                            top: 1,
                                          ),
                                          child: CachedNetworkImage(
                                            height: 15,
                                            imageUrl:
                                                "https://webstockreview.net/images/confirmation-clipart-verified.png",
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8,
                                      bottom: 1,
                                    ),
                                    child: Text(
                                      ".",
                                      style: GoogleFonts.rubik(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      tAgo.format(
                                        real.data()["timestamp"].toDate(),
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                real.data()["role"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.25,
                                child: Text(
                                  real.data()["caption"],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.w500,
                                    height: 1.4,
                                    //fontSize: 17,
                                  ),
                                ),
                              ),
                              real.data()["url"] == ""
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : SizedBox(
                                      height: 12,
                                    ),
                              real.data()["url"] == ""
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        pushNewScreen(
                                          context,
                                          withNavBar: false,
                                          customPageRoute: MorpheusPageRoute(
                                            builder: (context) => DetailScreen(
                                              image: real.data()["url"],
                                            ),
                                            transitionDuration: Duration(
                                              milliseconds: 130,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          height: 250,
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                real.data()["url"],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              likePost(real.data()["postId"]);
                            },
                            label: Text(
                              real.data()["likes"].length.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            icon: real.data()["likes"].contains(currentUser.id)
                                ? Icon(
                                    AntDesign.heart,
                                    color: Colors.red,
                                    size: 20,
                                  )
                                : Icon(
                                    Feather.heart,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => CommentRealTime(
                                    postID: real.data()["postId"],
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                            },
                            label: Text(
                              "Comment",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            icon: Icon(
                              MaterialCommunityIcons.comment_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          FlatButton.icon(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Fluttertoast.showToast(
                                msg: "Thank you for reporting!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            },
                            icon: Icon(
                              Feather.flag,
                              color: Colors.grey,
                              size: 20,
                            ),
                            label: Text(
                              "Report",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  likePost(String id) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("realTimeTweets")
        .doc(id)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance.collection("realTimeTweets").doc(id).update({
        'likes': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      FirebaseFirestore.instance.collection("realTimeTweets").doc(id).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}
