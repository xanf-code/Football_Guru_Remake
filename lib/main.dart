import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';

const String boxName = 'favs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final doc = await getApplicationDocumentsDirectory();
  Hive.init(doc.path);
  Hive.registerAdapter(FavouritesAdapter());
  await Hive.openBox<Favourites>(boxName);
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
