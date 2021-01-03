import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Repository extends ChangeNotifier {
  Repository(this._firestore) : assert(_firestore != null);

  final FirebaseFirestore _firestore;

  getForum(forumName) {
    return _firestore
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .orderBy("timestamp", descending: true);
  }

  getWallpaper(forumName) {
    return _firestore.collection(forumName).snapshots();
  }

  getPoll(forumName) {
    return _firestore
        .collection("Forum")
        .doc(forumName)
        .collection("Polls")
        .orderBy("timestamp", descending: true);
  }

  Stream getMessages(ref, limit) {
    return _firestore
        .collection("ChatsCollection")
        .doc(ref)
        .collection("chats")
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }
}
