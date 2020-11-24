import 'dart:convert';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;

import 'package:transfer_news/Model/tmnewsmodel.dart';

class NewsList {
  List<TMNewsModel> allNews = [];
  Future<void> getLatestNews() async {
    String url =
        "https://tmnewsapi.herokuapp.com/tran/tranapinews/?format=json";
    var response = await http.get(url);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      jsonData.forEach(
        (element) {
          TMNewsModel tmNewsModel = TMNewsModel(
            id: element["id"],
            headline: element["headline"],
            subline: element["subline"],
            articleLink: element["articleLink"],
            articleImage: element["articleImage"],
            topImage: element["topImage"],
            DateTime: element["DateTime"],
          );
          allNews.add(tmNewsModel);
        },
      );
    }
  }
}
