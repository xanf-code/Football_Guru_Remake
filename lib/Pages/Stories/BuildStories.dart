// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:stories_for_flutter/stories_for_flutter.dart';
// import 'package:transfer_news/Pages/Stories/updatePage.dart';
// import 'package:transfer_news/Pages/home.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
//
// class BuildStories extends StatefulWidget {
//   @override
//   _BuildStoriesState createState() => _BuildStoriesState();
// }
//
// class _BuildStoriesState extends State<BuildStories> {
//   List AllStories;
//
//   Future<String> getStories() async {
//     final headers = {'Content-Type': 'application/json'};
//
//     var response = await http.get(
//       "https://storiesbackendapi.herokuapp.com/api/postStories/",
//       headers: headers,
//     );
//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);
//       setState(() {
//         AllStories = jsonResponse;
//       });
//     } else {
//       print(response.statusCode);
//     }
//   }
//
//   Timer timer;
//
//   @override
//   void initState() {
//     //getStories();
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getStories());
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DelayedDisplay(
//       fadingDuration: const Duration(milliseconds: 500),
//       slidingCurve: Curves.decelerate,
//       delay: Duration(milliseconds: 100),
//       child: Container(
//         height: 110,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   HapticFeedback.mediumImpact();
//                   Navigator.push(
//                     context,
//                     CupertinoPageRoute(
//                       builder: (context) => UploadPage(
//                         gCurrentUser: currentUser,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 14.0, top: 1),
//                       child: CircleAvatar(
//                         radius: 31,
//                         backgroundColor: Color(0xFF7232f2),
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: CachedNetworkImageProvider(
//                             (currentUser.url),
//                           ),
//                           child: Icon(
//                             AntDesign.plus,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0),
//                       child: Text(
//                         "Add Stories",
//                         style: GoogleFonts.cabin(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               AllStories == null
//                   ? SizedBox()
//                   : ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       itemCount: AllStories.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                             top: 8,
//                             left: 8.0,
//                           ),
//                           child: Stories(
//                             //showThumbnailOnFullPage: false,
//                             circlePadding: 2,
//                             displayProgress: true,
//                             storyCircleTextStyle: GoogleFonts.cabin(
//                               color: Colors.white,
//                             ),
//                             storyItemList: [
//                               StoryItem(
//                                 name: AllStories[index]["name"],
//                                 thumbnail: CachedNetworkImageProvider(
//                                   AllStories[index]["url"],
//                                 ),
//                                 stories: [
//                                   Scaffold(
//                                     body: Container(
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: CachedNetworkImageProvider(
//                                             AllStories[index]["url"],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
