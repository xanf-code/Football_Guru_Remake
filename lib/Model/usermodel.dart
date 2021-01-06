import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserModel {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final bool isBlocked;
  final bool isAdmin;
  final bool isVerified;
  final bool subscribed;
  FirebaseUserModel({
    this.subscribed,
    this.isAdmin,
    this.isVerified,
    this.isBlocked,
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
  });
  factory FirebaseUserModel.fromDocument(DocumentSnapshot doc) {
    return FirebaseUserModel(
      id: doc.id,
      email: doc["email"],
      url: doc["photoUrl"],
      profileName: doc["displayName"],
      username: doc["username"],
      isBlocked: doc["isBlocked"],
      isAdmin: doc["isAdmin"],
      isVerified: doc["verified"],
      subscribed: doc["subscribed"],
    );
  }
}
