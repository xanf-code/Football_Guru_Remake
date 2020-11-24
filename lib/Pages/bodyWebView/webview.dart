// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewPage extends StatefulWidget {
//   final String url;
//   final String headline;
//   const WebViewPage({Key key, this.url, this.headline}) : super(key: key);
//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Color(0xFF0e0e10),
//         title: Text(
//           widget.headline,
//           style: GoogleFonts.ubuntu(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
