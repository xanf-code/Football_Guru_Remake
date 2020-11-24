import 'package:hive/hive.dart';

part 'chatModel.g.dart';

@HiveType(typeId: 0)
class Favourites {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String bg;
  @HiveField(2)
  final String logo;
  @HiveField(3)
  final String appTitle;
  @HiveField(4)
  final String ref;
  @HiveField(5)
  final bool isSaved;

  Favourites(
      {this.isSaved, this.title, this.bg, this.logo, this.appTitle, this.ref});
}
