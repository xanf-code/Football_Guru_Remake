import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsCardWidget extends StatefulWidget {
  final String url;

  const NewsCardWidget({Key key, this.url}) : super(key: key);
  @override
  _NewsCardWidgetState createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget>
    with AutomaticKeepAliveClientMixin<NewsCardWidget> {
  List newsData;

  Future<String> getAllNews() async {
    var response = await http.get(widget.url);
    if (response.statusCode == 200) {
      var jsonresponse = json.decode(response.body);
      setState(() {
        newsData = jsonresponse["news"]["dataset"];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getAllNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return newsData == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: newsData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => WebviewScaffold(
                        url: newsData[index]["page"]["url"],
                        appBar: AppBar(
                          backgroundColor: Color(0xFF0e0e10),
                          title: Text(newsData[index]["title"]),
                        ),
                        hidden: true,
                        initialChild: Container(
                          color: Color(0xFF0e0e10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    newsData[index]["imageUrl"]),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8),
                          child: Text(
                            newsData[index]["title"],
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 12, top: 8, bottom: 8),
                          child: Text(
                            newsData[index]["sourceStr"],
                            style: GoogleFonts.rubik(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
