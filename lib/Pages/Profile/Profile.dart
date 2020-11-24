// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
// import 'package:transfer_news/Model/usermodel.dart';
// import 'package:transfer_news/Pages/home.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String userProfileId;
//
//   const ProfilePage({Key key, this.userProfileId}) : super(key: key);
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   bool loading = false;
//
//   createProfileTopView() {
//     return FutureBuilder(
//       future: usersReference.document(widget.userProfileId).get(),
//       builder: (context, dataSnapshot) {
//         if (!dataSnapshot.hasData) {
//           return LinearProgressIndicator();
//         }
//         User user = User.fromDocument(dataSnapshot.data);
//         return Padding(
//           padding: EdgeInsets.only(top: 30.0, bottom: 15),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 45,
//                     backgroundImage: CachedNetworkImageProvider(user.url),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         user.profileName,
//                         style: GoogleFonts.ubuntu(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         user.email,
//                         style: GoogleFonts.ubuntu(
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w400,
//                           fontSize: 14,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   logOutUser() {
//     gSignIn.signOut();
//   }

//   profilePageButtons() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         buttons(
//           icon: LineAwesomeIcons.cog,
//           text: "Settings",
//         ),
//         buttons(
//           icon: LineAwesomeIcons.user_plus,
//           text: "Invite a Friend",
//         ),
//         buttons(
//           icon: LineAwesomeIcons.question_circle,
//           text: "Help & Support",
//         ),
//         buttons(
//           icon: LineAwesomeIcons.user_secret,
//           text: "Privacy",
//         ),
//         GestureDetector(
//           onTap: () {
//             logOutUser();
//             Navigator.pop(context);
//           },
//           child: buttons(
//             icon: LineAwesomeIcons.sign_out,
//             text: "Logout",
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0e0e10),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0e0e10),
//         title: Text("Profile"),
//         centerTitle: false,
//       ),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: [
//           createProfileTopView(),
//           profilePageButtons(),
//         ],
//       ),
//     );
//   }
// }
//
// class buttons extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   const buttons({
//     Key key,
//     this.icon,
//     this.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 10 * 5.5,
//       margin: EdgeInsets.symmetric(
//         horizontal: 10 * 4.0,
//       ).copyWith(bottom: 10 * 2.0),
//       decoration: BoxDecoration(
//         gradient: new LinearGradient(
//           colors: [
//             const Color(0xFF3366FF),
//             const Color(0xFF00CCFF),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               this.icon,
//               size: 10 * 2.5,
//               color: Colors.white,
//             ),
//             SizedBox(
//               width: 10 * 2.5,
//             ),
//             Text(
//               this.text,
//               style: GoogleFonts.ubuntu(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             Spacer(),
//             Icon(
//               SimpleLineIcons.arrow_right,
//               size: 10,
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/unicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Pages/Profile/privacypolicies.dart';
import 'package:transfer_news/Pages/Profile/terms&cond.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  const ProfilePage({Key key, this.userProfileId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  logOutUser() {
    gSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        CachedNetworkImageProvider(currentUser.url),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    currentUser.username,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFF0e0e10),
                            title: Text(
                              "Socials",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    launch("https://www.instagram.com/iftwc_/");
                                  },
                                  child: Row(
                                    children: [
                                      Unicon(
                                        UniconData.uniInstagramAlt,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Instagram",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    launch("https://www.facebook.com/IFTWC/");
                                  },
                                  child: Row(
                                    children: [
                                      Unicon(
                                        UniconData.uniFacebookF,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Facebook",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    launch("https://twitter.com/iftwc");
                                  },
                                  child: Row(
                                    children: [
                                      Unicon(
                                        UniconData.uniTwitterAlt,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Twitter",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    launch(
                                        "https://www.youtube.com/channel/UCzrGZMoQE_XrnAj7HEM1tRw");
                                  },
                                  child: Row(
                                    children: [
                                      Unicon(
                                        UniconData.uniYoutube,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Youtube",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Close"),
                              ),
                            ],
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Socials",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      pushNewScreen(
                        context,
                        withNavBar: false,
                        customPageRoute: MorpheusPageRoute(
                          builder: (context) => PolicyPage(),
                          transitionDuration: Duration(
                            milliseconds: 200,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Terms And Condition",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Playstore",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Share",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.volume_up_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Notifications",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                buildNotificationOptionRow("News for you", true),
                buildNotificationOptionRow("Notifications", true),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: FlatButton(
                    color: Color(0xFF7232f2),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      logOutUser();
                      Navigator.pop(context);
                    },
                    child: Text("SIGN OUT",
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[300]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}
