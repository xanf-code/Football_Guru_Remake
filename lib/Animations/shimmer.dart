import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList();
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;
          return Shimmer.fromColors(
            highlightColor: Color(0xFF7232f2),
            baseColor: Colors.black,
            child: ShimmerLayout(),
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 30;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 20,
                  width: containerWidth,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 18,
                  width: containerWidth * 0.75,
                  color: Colors.grey,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
