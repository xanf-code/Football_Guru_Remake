import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_news/Pages/home.dart';

class PollLogic extends ChangeNotifier {
  checkAndAdd(postID, String optionID, route) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(route)
        .collection("Polls")
        .doc(postID)
        .get();
    if (docs.data()['usersVoted'].contains(currentUser.id)) {
      Fluttertoast.showToast(
        msg: "You have already voted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(route)
          .collection("Polls")
          .doc(postID)
          .update({
        'usersVoted': FieldValue.arrayUnion(
          [currentUser.id],
        )
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection("Forum")
            .doc(route)
            .collection("Polls")
            .doc(postID)
            .update(
          {
            optionID: FieldValue.increment(1),
          },
        );
      });
    }
  }

  removePost(String postID, route) async {
    await FirebaseFirestore.instance
        .collection("Forum")
        .doc(route)
        .collection("Polls")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  likePost(String id, route) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(route)
        .collection("Polls")
        .doc(id)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
        ..collection("Forum").doc(route).collection("Polls").doc(id).update({
          'likes': FieldValue.arrayRemove(
            [currentUser.id],
          )
        });
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(route)
          .collection("Polls")
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}
