import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/Stories/updatePage.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Widgets/StoryPage.dart';
import 'package:transfer_news/Widgets/storyCard.dart';

class Stories extends StatelessWidget {
  const Stories();
  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      fadingDuration: const Duration(milliseconds: 500),
      slidingCurve: Curves.decelerate,
      delay: Duration(milliseconds: 100),
      child: Container(
        height: 90,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("stories")
              .where(
                "timestamp",
                isGreaterThan: DateTime.now().subtract(Duration(hours: 24)),
              )
              .orderBy(
                "timestamp",
                descending: true,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        pushNewScreen(
                          context,
                          withNavBar: false,
                          customPageRoute: MorpheusPageRoute(
                            builder: (context) => UploadPage(
                              gCurrentUser: currentUser,
                            ),
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                          ),
                        );
                      },
                      child: StoryDesign(
                        image: currentUser.url,
                        name: currentUser.username,
                        isUpload: true,
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length == null
                          ? 0
                          : snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data == null) {
                          return SizedBox();
                        } else {
                          return InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              viewCounter(
                                snapshot.data.docs[index]["postId"],
                              );
                              pushNewScreen(
                                context,
                                withNavBar: false,
                                customPageRoute: MorpheusPageRoute(
                                  builder: (context) => StoryPage(
                                    url: snapshot.data.docs[index]["url"],
                                    caption: snapshot.data.docs[index]
                                        ["caption"],
                                    userPic: snapshot.data.docs[index]
                                        ["userPic"],
                                    userName: snapshot.data.docs[index]["name"],
                                    viewCount: snapshot
                                        .data.docs[index]["viewed"].length
                                        .toString(),
                                  ),
                                  transitionDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                              );
                            },
                            child: StoryDesign(
                              image: snapshot.data.docs[index]["url"],
                              name: snapshot.data.docs[index]["name"],
                              isUpload: false,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  viewCounter(String docID) async {
    await FirebaseFirestore.instance.collection("stories").doc(docID).update({
      'viewed': FieldValue.arrayUnion(
        [currentUser.id],
      )
    });
  }
}
