import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final bool isBlocked;

  User({
    this.isBlocked,
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
  });
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      email: doc["email"],
      url: doc["photoUrl"],
      profileName: doc["displayName"],
      username: doc["username"],
      isBlocked: doc["isBlocked"],
    );
  }
}
