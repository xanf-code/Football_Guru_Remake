import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:transfer_news/Behaviour/customScrollBehaviour.dart';
import 'package:transfer_news/Forum/Widgets/PollContainer.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Forum/Logics/forumLogic.dart';
import 'package:transfer_news/Forum/Logics/logics.dart';
import 'package:transfer_news/RealTime/Logic/RTLogics.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/Logics.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/videoPlayerItems.dart';
import 'package:transfer_news/Repo/repo.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Repository(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider.value(
          value: PollContainer(),
        ),
        ChangeNotifierProvider.value(
          value: PollLogic(),
        ),
        ChangeNotifierProvider.value(
          value: ForumLogic(),
        ),
        ChangeNotifierProvider.value(
          value: RTLogics(),
        ),
        ChangeNotifierProvider.value(
          value: VideoPlayerItems(),
        ),
        ChangeNotifierProvider.value(
          value: ReelsLogic(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
          highlightColor: Color(0xFF7232f2),
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        home: MyHomePage(),
      ),
    );
  }
}
