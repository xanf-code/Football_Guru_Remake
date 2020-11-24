// To parse this JSON data, do
//
//     final storiesModel = storiesModelFromJson(jsonString);

import 'dart:convert';

StoriesModel storiesModelFromJson(String str) =>
    StoriesModel.fromJson(json.decode(str));

String storiesModelToJson(StoriesModel data) => json.encode(data.toJson());

class StoriesModel {
  StoriesModel({
    this.id,
    this.name,
    this.ownerId,
    this.postId,
    this.url,
    this.timestamp,
    this.v,
  });

  String id;
  String name;
  String ownerId;
  String postId;
  String url;
  DateTime timestamp;
  int v;

  factory StoriesModel.fromJson(Map<String, dynamic> json) => StoriesModel(
        id: json["_id"],
        name: json["name"],
        ownerId: json["ownerID"],
        postId: json["postId"],
        url: json["url"],
        timestamp: DateTime.parse(json["timestamp"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "ownerID": ownerId,
        "postId": postId,
        "url": url,
        "timestamp": timestamp.toIso8601String(),
        "__v": v,
      };
}
