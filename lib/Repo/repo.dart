import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  Repository(this._firestore) : assert(_firestore != null);

  final FirebaseFirestore _firestore;

  Stream getForum(forumName, limit) {
    return _firestore
        .collection("Forum")
        .doc(forumName)
        .collection("Posts")
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream getPoll(forumName, limit) {
    return _firestore
        .collection("Forum")
        .doc(forumName)
        .collection("Polls")
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
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
