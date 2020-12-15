import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String postID;
  const DetailScreen({
    Key key,
    this.image,
    this.postID,
  }) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Stack(
        children: [
          GestureDetector(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.image,
              ),
            ),
            onHorizontalDragDown: (_) {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              splashColor: Colors.transparent,
              splashRadius: 1,
              icon: Icon(
                Feather.download,
                color: Colors.white,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                requestPermission();
                saveImage();
                Fluttertoast.showToast(
                  msg: "Image Saved to Gallery",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  saveImage() async {
    var response = await Dio().get(
      widget.image,
      options: Options(responseType: ResponseType.bytes),
    );
    await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 80,
      name: widget.postID,
    );
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }
}
