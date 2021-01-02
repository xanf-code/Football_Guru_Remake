import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:transfer_news/Pages/home.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart' as joinPath;

class ForumLogic extends ChangeNotifier {
  var documentDirectory;

  removePost(postID, forumName) async {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    //Delete Post Pic from Storage
    forumReference.child("post_$postID.jpg").delete();

    // Post Individual
    FirebaseFirestore.instance
        .collection("Individual Tweets")
        .doc(currentUser.id)
        .collection("Forum Posts")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  reportPost(postId, forumName) {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(forumName)
        .collection("Reports")
        .add({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
    }).then((result) {
      Fluttertoast.showToast(
        msg: "Thank you for reporting!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    });
  }

  starPost(postID, forumName) async {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .doc(postID)
        .update({
      "top25": true,
    });
  }

  removestarPost(postID, forumName) async {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .doc(postID)
        .update({
      "top25": false,
    });
  }

  likePost(String id, forumName) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .doc(id)
        .get();
    if (docs.data()['likes'].contains(currentUser.id)) {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(forumName)
          .collection("Posts")
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      FirebaseFirestore.instance
          .collection("Forum")
          .doc(forumName)
          .collection("Posts")
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }

  imageDownload(String url, String text, String postID) async {
    var response = await get(url);
    documentDirectory = await getTemporaryDirectory();
    File file = new File(joinPath.join(documentDirectory.path, '$postID.png'));
    file.writeAsBytesSync(response.bodyBytes);
    Share.shareFiles(
      [file.path],
      text: text,
    );
  }
}
