import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';

class RealTimePostsMade extends StatefulWidget {
  @override
  _RealTimePostsMadeState createState() => _RealTimePostsMadeState();
}

class _RealTimePostsMadeState extends State<RealTimePostsMade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text("Real Time Posts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Individual Tweets")
            .doc(currentUser.id)
            .collection("tweets")
            .orderBy(
              "timestamp",
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF7232f2),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              snapshot.data.docs[index]["url"] == ""
                                  ? "https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png"
                                  : snapshot.data.docs[index]["url"],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]["caption"],
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  tAgo.format(
                                    snapshot.data.docs[index]["timestamp"]
                                        .toDate(),
                                  ),
                                  style: GoogleFonts.rubik(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              removePost(
                                snapshot.data.docs[index]["postId"],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Remove Post
  removePost(postID) async {
    FirebaseFirestore.instance
        .collection("realTimeTweets")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    FirebaseFirestore.instance
        .collection("Individual Tweets")
        .doc(currentUser.id)
        .collection("tweets")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    realTimeReference.child("post_$postID.jpg").delete();
  }
}
