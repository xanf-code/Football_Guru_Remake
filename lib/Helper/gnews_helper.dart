import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:transfer_news/Model/tmnewsmodel.dart';

class GoogleNewsList {
  List<GNewsAll> allGNews = [];
  Future<void> getLatestGNews() async {
    String url = "https://gnewsall.herokuapp.com/news/gnewsAPI/?format=json";
    var response = await http.get(url);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      jsonData.forEach(
        (element) {
          GNewsAll gNewsAll = GNewsAll(
            id: element["id"],
            headlines: element["headlines"],
            desc: element["desc"],
            link: element["link"],
            source: element["source"],
            date: element["date"],
            image: element["image"],
          );
          allGNews.add(gNewsAll);
        },
      );
    }
  }
}
