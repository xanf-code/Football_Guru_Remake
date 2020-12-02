import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  PostRepository._();

  static PostRepository _instance = PostRepository._();
  static PostRepository get instance => _instance;

  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection("realTimeTweets");

  Stream<QuerySnapshot> getPosts() {
    return _postCollection
        .limit(15)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsPage(DocumentSnapshot lastDoc) {
    return _postCollection
        .limit(15)
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDoc)
        .snapshots();
  }
}
