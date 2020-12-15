import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:transfer_news/Pages/home.dart';

class RTLogics extends ChangeNotifier {
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
