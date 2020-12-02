import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Tweets extends Equatable {
  final String caption;
  final String postID;
  final String role;
  final String url;
  final bool isVerified;
  final dynamic likes;
  final String username;
  final String userPic;
  final Timestamp timestamp;

  const Tweets(
    this.caption,
    this.postID,
    this.role,
    this.url,
    this.isVerified,
    this.likes,
    this.username,
    this.userPic,
    this.timestamp,
  );

  factory Tweets.fromSnapshot(Map data) {
    return Tweets(
      data['caption'],
      data['postId'],
      data["role"],
      data["url"],
      data["isVerified"],
      data["likes"],
      data["name"],
      data["userPic"],
      data["timestamp"],
    );
  }

  @override
  List<Object> get props => [
        caption,
        postID,
        role,
        url,
        isVerified,
        likes,
        username,
        userPic,
        timestamp,
      ];
}
