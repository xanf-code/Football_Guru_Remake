// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:transfer_news/Animations/shimmer.dart';
// import 'package:transfer_news/Pages/LiveScore/live.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class CategoryNewsWidget extends StatefulWidget {
//   final int catID;
//   final String title;
//   const CategoryNewsWidget({Key key, this.catID, this.title}) : super(key: key);
//   @override
//   _CategoryNewsWidgetState createState() => _CategoryNewsWidgetState();
// }
//
// class _CategoryNewsWidgetState extends State<CategoryNewsWidget>
//     with AutomaticKeepAliveClientMixin<CategoryNewsWidget> {
//   List ILeaguenewsData;
//
//   Future<String> getNews() async {
//     var response = await http.get(
//       "https://iftwc.com/wp-json/wp/v2/posts?categories=${widget.catID}",
//     );
//     if (response.statusCode == 200) {
//       var jsonresponse = json.decode(utf8.decode(response.bodyBytes));
//       setState(() {
//         ILeaguenewsData = jsonresponse;
//       });
//     } else {
//       print(response.statusCode);
//     }
//   }
//
//   @override
//   void initState() {
//     getNews();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0e0e10),
//         title: Text(widget.title),
//       ),
//       backgroundColor: Color(0xFF0e0e10),
//       body: ILeaguenewsData == null
//           ? ShimmerList()
//           : ILeagueNewsWidget(ILeaguenewsData: ILeaguenewsData),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
//
// class ILeagueNewsWidget extends StatelessWidget {
//   const ILeagueNewsWidget({
//     Key key,
//     @required this.ILeaguenewsData,
//   }) : super(key: key);
//
//   final List ILeaguenewsData;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: ClampingScrollPhysics(),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DelayedDisplay(
//             fadingDuration: const Duration(milliseconds: 800),
//             slidingCurve: Curves.decelerate,
//             delay: Duration(milliseconds: 200),
//             child: LiveScoreWidget(
//               leagueId: 0,
//             ),
//           ),
//           DelayedDisplay(
//             fadingDuration: const Duration(milliseconds: 800),
//             slidingCurve: Curves.decelerate,
//             delay: Duration(milliseconds: 300),
//             child: ListView.separated(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               separatorBuilder: (context, _) {
//                 return Divider(
//                   color: Colors.grey[800],
//                   indent: 20,
//                   endIndent: 20,
//                 );
//               },
//               itemCount: ILeaguenewsData.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     HapticFeedback.mediumImpact();
//                     Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                         builder: (context) => WebviewScaffold(
//                           url: ILeaguenewsData[index]["link"],
//                           appBar: AppBar(
//                             backgroundColor: Color(0xFF0e0e10),
//                             title: Text(
//                               ILeaguenewsData[index]["title"]["rendered"],
//                             ),
//                           ),
//                           hidden: true,
//                           initialChild: Container(
//                             color: Color(0xFF0e0e10),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   child: Stack(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Container(
//                               height: 250,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: CachedNetworkImageProvider(
//                                     ILeaguenewsData[index][
//                                                 "jetpack_featured_media_url"] ==
//                                             ""
//                                         ? "https://www.globalpharmatek.com/wp-content/uploads/2016/10/orionthemes-placeholder-image.jpg"
//                                         : ILeaguenewsData[index]
//                                             ["jetpack_featured_media_url"],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 16.0, right: 8),
//                             child: Html(
//                               data: ILeaguenewsData[index]["title"]["rendered"],
//                               defaultTextStyle: GoogleFonts.rubik(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 16.0, right: 12, top: 8, bottom: 8),
//                                 child: Text(
//                                   Jiffy(
//                                     ILeaguenewsData[index]["date"],
//                                     "yyyy-MM-dd",
//                                   ).fromNow(),
//                                   style: GoogleFonts.rubik(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 18.0,
//                                   //right: 12,
//                                   top: 8,
//                                   bottom: 8,
//                                 ),
//                                 child: Text(
//                                   ILeaguenewsData[index]["custom"]["author"]
//                                       ["name"],
//                                   style: GoogleFonts.rubik(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
