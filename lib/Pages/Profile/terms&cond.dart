import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/AppPolicies/policies.dart';
import 'package:url_launcher/url_launcher.dart';

class termsAndCond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0e10),
        title: Text("Terms And Conditions"),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(
            data: TC,
            defaultTextStyle: GoogleFonts.rubik(
              color: Colors.grey[400],
              fontSize: 16,
              //fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            onLinkTap: (value) {
              launch(value);
            },
          ),
        ),
      ),
    );
  }
}
