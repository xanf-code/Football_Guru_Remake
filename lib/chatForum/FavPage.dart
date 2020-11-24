// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:transfer_news/chatForum/databaseHelper/chatHelper.dart';
// import 'package:transfer_news/chatForum/databaseModel/chatModel.dart';
//
// class FavouritesScreen extends StatefulWidget {
//   @override
//   _FavouritesScreenState createState() => _FavouritesScreenState();
// }
//
// class _FavouritesScreenState extends State<FavouritesScreen> {
//   List<Favourites> favouritesList;
//   int count = 0;
//   DatabaseController databaseController = DatabaseController();
//
//   @override
//   void initState() {
//     super.initState();
//     setData();
//   }
//
//   Future<void> setData() async {
//     favouritesList = await databaseController.getFavList();
//     if (mounted) {
//       setState(() {
//         count = favouritesList.length;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return body();
//   }
//
//   body() {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0e0e10),
//         title: Text("Favourites"),
//       ),
//       backgroundColor: Color(0xFF0e0e10),
//       body: ListView.builder(
//         itemCount: count,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             // onTap: () {
//             //   getDetail(movieList[index]);
//             // },
//             leading: favouritesList[index].logo == null
//                 ? Icon(Icons.broken_image)
//                 : CachedNetworkImage(
//                     imageUrl: favouritesList[index].logo,
//                     width: 50.0,
//                     height: 50.0),
//             title: Text(favouritesList[index].title),
//
//             trailing: GestureDetector(
//               child: Icon(Icons.delete, color: Colors.red),
//               onTap: () {
//                 databaseController.deleteData(favouritesList[index].id);
//                 //favouritesList[index].favorite = false;
//                 if (mounted) {
//                   setState(
//                     () {
//                       setData();
//                     },
//                   );
//                 }
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
