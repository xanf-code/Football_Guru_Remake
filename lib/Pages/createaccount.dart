import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Pages/constants/constants.dart';
import 'package:transfer_news/Pages/home.dart';

class CreateAccountPage extends StatefulWidget {
  // final String club;
  final TextEditingController username;

  CreateAccountPage({
    // this.club,
    this.username,
  });
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  String username;
  //String clubName;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  submitUsername() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      SnackBar snackBar = SnackBar(
        content: Text("Welcome ${widget.username.text}"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pop(context, username);
        },
      );
    }
  }

  // final List<String> teams = [
  //   'Bengaluru FC',
  //   'Kerala Blasters FC',
  //   'Jamshedpur FC',
  //   'ATK Mohun Bagan FC',
  //   'Techtro Swadesh FC'
  // ];

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        key: _scaffoldKey,
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.blueAccent,
                    child: Text(
                      'Setup Username',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(17),
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          style: GoogleFonts.ubuntu(color: Colors.white),
                          validator: (val) {
                            if (val.trim().length < 5 || val.isEmpty) {
                              return "User Name is Short";
                            } else if (val.trim().length > 15) {
                              return "User Name is Very long";
                            } else {
                              return null;
                            }
                          },
                          //onSaved: (val) => username = val,
                          controller: widget.username,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: InputBorder.none,
                            labelText: "Username",
                            labelStyle: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: "Must be at least 5 characters",
                            hintStyle:
                                GoogleFonts.montserrat(color: Colors.grey),
                          ),
                          autocorrect: true,
                          //autofocus: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(17.0),
              //   child: DropdownButtonFormField(
              //     dropdownColor: Colors.black,
              //     style: GoogleFonts.ubuntu(
              //       fontSize: 16,
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     value: clubName,
              //     onChanged: (val) {
              //       setState(() {
              //         clubName = val;
              //       });
              //
              //       print(widget.club);
              //     },
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Colors.grey[900],
              //       border: InputBorder.none,
              //       labelText: "Select Club",
              //       labelStyle: GoogleFonts.ubuntu(
              //         fontSize: 16,
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     items: teams.map((team) {
              //       return DropdownMenuItem(
              //         child: Text("$team"),
              //         value: team,
              //       );
              //     }).toList(),
              //   ),
              // ),
              GestureDetector(
                onTap: submitUsername,
                child: Container(
                  height: 55,
                  width: 360,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF3366FF),
                        const Color(0xFF00CCFF),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Proceed",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
