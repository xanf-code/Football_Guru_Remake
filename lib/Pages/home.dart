import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/RoutePage/forumPage.dart';
import 'package:transfer_news/Model/usermodel.dart';
import 'package:transfer_news/Pages/LeaguesIntro.dart';
import 'package:transfer_news/Forum/Forum.dart';
import 'package:transfer_news/Pages/News.dart';
import 'package:transfer_news/Pages/Profile/terms&cond.dart';
import 'package:transfer_news/Pages/Transfers/transfers.dart';
import 'package:transfer_news/RealTime/RealTimePage.dart';
import 'createaccount.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = FirebaseFirestore.instance.collection("users");
final postsReference = FirebaseFirestore.instance.collection("posts");
final votesReference = FirebaseFirestore.instance.collection("PlayerBattle");
final chatsReference = FirebaseFirestore.instance.collection("ChatsCollection");
final DateTime timeStamp = DateTime.now();
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posts Pictures");
final StorageReference storyReference =
    FirebaseStorage.instance.ref().child("Stories Pictures");
final StorageReference realTimeReference =
    FirebaseStorage.instance.ref().child("RealTime Pictures");
final StorageReference chatImagesReferences =
    FirebaseStorage.instance.ref().child("Chats Pictures");
final StorageReference forumReference =
    FirebaseStorage.instance.ref().child("Public Forum");
final StorageReference reelsReference =
    FirebaseStorage.instance.ref().child("Reels");
final activityReference = FirebaseFirestore.instance.collection("feed");
final commentsReference = FirebaseFirestore.instance.collection("comments");
final allPostsReference = FirebaseFirestore.instance.collection("allPosts");
final featuredPostsReference =
    FirebaseFirestore.instance.collection("featuredPosts");

User currentUser;

class MyHomePage extends StatefulWidget {
  final User gCurrentUser;

  const MyHomePage({Key key, this.gCurrentUser}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _isSignedIn = false;
  int currentIndex = 0;
  bool singningIn = false;
  PersistentTabController _controller;
  Timer timer;
  //String clubName;
  TextEditingController userController = TextEditingController();

  _configureFirebaseListening() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        navigationOfNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        navigationOfNotification(message);
      },
    );
  }

  void navigationOfNotification(Map<String, dynamic> message) {
    final notification = message['notification'];
    var data = message["data"];
    var view = data["view"];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");

    if (view != null) {
      if (view == 'real_time') {
        NavigationController(
          RealTimeUI(
            gCurrentUser: currentUser,
          ),
        );
      }
      if (view == 'ISL_forum') {
        NavigationController(
          ForumDetails(
            forumName: "ISL",
            tagName: [
              'Off topic',
              'Bengaluru FC',
              'Kerala Blasters FC',
              'Jamshedpur FC',
              'ATK Mohun Bagan FC',
              'Mumbai City',
              'NorthEast United FC',
              'Chennaiyin FC',
              'Hyderabad FC',
              'FC Goa',
              'Odisha FC',
              'East Bengal FC',
            ],
            appBar: "Indian Super League",
          ),
        );
      }
    }
    if (view == 'NT_forum') {
      NavigationController(
        ForumDetails(
          forumName: "National Team",
          tagName: [
            'Off topic',
            'National Team',
            'Women\'s National Team',
            'U-17 National Team',
            'U-20 National Team',
            'World Cup Qualifiers',
            'FIFA U-17 Women\'s World Cup',
          ],
          appBar: "National Team",
        ),
      );
    }
  }

  Future<Object> NavigationController(router) {
    return pushNewScreen(
      context,
      withNavBar: false,
      customPageRoute: MorpheusPageRoute(
        builder: (context) => router,
        transitionDuration: Duration(
          milliseconds: 200,
        ),
      ),
    );
  }

  controllSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();
      setState(() {
        _isSignedIn = true;
      });
    } else {
      setState(() {
        _isSignedIn = false;
      });
    }
  }

  bool isBlocked = false;
  bool isAdmin = false;
  bool isVerified = false;
  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.doc(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CreateAccountPage(
            username: userController,
          ),
        ),
      );
      usersReference.doc(gCurrentUser.id).set({
        "id": gCurrentUser.id,
        "email": gCurrentUser.email,
        "photoUrl": gCurrentUser.photoUrl,
        "displayName": gCurrentUser.displayName,
        "username": userController.text,
        "timeStamp": timeStamp,
        "isBlocked": isBlocked,
        "isAdmin": isAdmin,
        "verified": isVerified,
      });
      documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  loginUser() async {
    setState(() {
      singningIn = true;
    });
    await gSignIn.signIn();
  }

  CachedVideoPlayerController controller;

  @override
  void initState() {
    _firebaseMessaging.subscribeToTopic("all");
    _configureFirebaseListening();
    controller = CachedVideoPlayerController.network(
      "https://iftwc.com/wp-content/uploads/2020/11/170804_C_Lombok_061.mp4",
    )..initialize().then((_) {
        controller.play();
        controller.setLooping(true);
        controller.setVolume(0);
        setState(() {});
      });
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message : " + gError);
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      setState(() {
        singningIn = true;
      });
      controllSignIn(gSignInAccount);
    }).catchError((gError) {
      print(gError);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      NewsPage(
        gCurrentUser: currentUser,
      ),
      Forum(
        gCurrentUser: currentUser,
      ),
      RealTimeUI(
        gCurrentUser: currentUser,
      ),
      AllTransfers(
        gCurrentUser: currentUser,
      ),
      Standings(
        gCurrentUser: currentUser,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          EvaIcons.homeOutline,
          size: 24,
        ),
        title: ("Home"),
        activeColor: Color(0xFF7232f2),
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          AntDesign.aliwangwang_o1,
          size: 24,
        ),
        title: ("Forum"),
        activeColor: Color(0xFF7232f2),
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Entypo.modern_mic,
          size: 24,
        ),
        title: ("Real Time"),
        activeColor: Color(0xFF7232f2),
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          EvaIcons.swap,
          size: 24,
        ),
        title: ("Transfers"),
        activeColor: Color(0xFF7232f2),
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CommunityMaterialIcons.scoreboard_outline,
          size: 24,
        ),
        title: ("Matches"),
        activeColor: Color(0xFF7232f2),
        inactiveColor: Colors.white70,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn && currentUser.isBlocked == false) {
      setState(() {
        singningIn = false;
      });
      return buildPersistentTabView();
    } else {
      return SignInPage();
    }
  }

  PersistentTabView buildPersistentTabView() {
    return PersistentTabView(
      navBarHeight: 60,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xFF0e0e10),
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: false,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: false,
      ),
      navBarStyle: NavBarStyle.style6,
      //3,9
    );
  }

  SignInPage() {
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size?.width ?? 0,
              height: controller.value.size?.height ?? 0,
              child: CachedVideoPlayer(controller),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                    height: 250,
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/transferapp-18e5d.appspot.com/o/assets%2Flogo2-removebg-preview.png?alt=media&token=3b4ca3d1-d770-4174-b88c-c7274d7e5d38"),
                //Spacer(),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 260,
                  child: MaterialButton(
                    elevation: 5,
                    color: Color(0xFF7232f2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          color: Colors.white,
                          height: 35,
                          imageUrl: "https://logodix.com/logo/584756.png",
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Google Sign In",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      loginUser();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "By sign in,you agree with our",
                    style: GoogleFonts.averageSans(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      pushNewScreen(
                        context,
                        withNavBar: false,
                        customPageRoute: MorpheusPageRoute(
                          builder: (context) => termsAndCond(),
                          transitionDuration: Duration(
                            milliseconds: 200,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Terms and Conditions.",
                      style: GoogleFonts.averageSans(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 50,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/transferapp-18e5d.appspot.com/o/assets%2Flogo2-removebg-preview.png?alt=media&token=3b4ca3d1-d770-4174-b88c-c7274d7e5d38",
              ),
              SizedBox(
                width: 12,
              ),
              CachedNetworkImage(
                height: 35,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/transferapp-18e5d.appspot.com/o/assets%2FFinalized%20Logo.png?alt=media&token=9d9d1662-5c18-49cc-9258-aebc88dcc026",
              ),
              SizedBox(
                width: 16,
              ),
              CachedNetworkImage(
                height: 35,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/transferapp-18e5d.appspot.com/o/assets%2FTechtro%20Sports%20Trust%20Final%20Logo%20Design%202.png?alt=media&token=262bba45-56a5-47c4-9796-ef83c493aef8",
              ),
            ],
          ),
        ),
        singningIn == true
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading..",
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                    ],
                  ),
                ),
              )
            : Text(""),
      ],
    );
  }
}
