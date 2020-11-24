import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupWidget extends StatelessWidget {
  final String groupName;
  final String sub;
  const GroupWidget({
    Key key,
    this.groupName,
    this.sub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        groupName,
        style: GoogleFonts.rubik(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        sub,
        style: GoogleFonts.rubik(
          color: Colors.white,
        ),
      ),
    );
  }
}
