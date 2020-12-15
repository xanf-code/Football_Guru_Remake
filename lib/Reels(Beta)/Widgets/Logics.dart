import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Utils/constants.dart';

class ReelsLogic extends ChangeNotifier {
  likes(String id) async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection("reels").doc(id).get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance.collection("reels").doc(id).update({
        'likes': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      FirebaseFirestore.instance.collection("reels").doc(id).update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }

  modalBottomSheetMenu(snapshot, context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: new BoxDecoration(
            color: appBG,
          ),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              removeVideo(snapshot, context);
              Navigator.of(context).pop();
            },
            child: ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              title: Text(
                "Delete Video",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  removeVideo(postID, context) {
    FirebaseFirestore.instance
        .collection("reels")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    }).whenComplete(() {
      Navigator.of(context).pop();
    });

    reelsReference.child("post_$postID.mp4").delete();
  }
}
