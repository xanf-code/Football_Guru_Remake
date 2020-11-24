class TMNewsModel {
  int id;
  String headline;
  String subline;
  String articleLink;
  String articleImage;
  String topImage;
  String DateTime;
  TMNewsModel({
    this.id,
    this.headline,
    this.subline,
    this.articleLink,
    this.articleImage,
    this.topImage,
    this.DateTime,
  });
}

class GNewsAll {
  int id;
  String headlines;
  String desc;
  String link;
  String source;
  String date;
  String image;
  GNewsAll({
    this.id,
    this.headlines,
    this.desc,
    this.link,
    this.source,
    this.date,
    this.image,
  });
}
