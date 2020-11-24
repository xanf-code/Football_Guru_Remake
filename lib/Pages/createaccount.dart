import 'dart:async';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transfer_news/Pages/constants/constants.dart';
import 'package:transfer_news/Pages/home.dart';

class CreateAccountPage extends StatefulWidget {
  final TextEditingController club;
  final TextEditingController username;
  final String league;

  const CreateAccountPage({Key key, this.club, this.username, this.league})
      : super(key: key);
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  String username;

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
                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.white),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
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

                        // SizedBox(
                        //   height: 20,
                        // ),
                        // // TextFormField(
                        // //   style: GoogleFonts.ubuntu(color: Colors.white),
                        // //   controller: widget.league,
                        // //   decoration: InputDecoration(
                        // //     filled: true,
                        // //     fillColor: Colors.grey[900],
                        // //     // focusedBorder: UnderlineInputBorder(
                        // //     //   borderSide: BorderSide(color: Colors.white),
                        // //     //   borderRadius: BorderRadius.circular(10),
                        // //     // ),
                        // //     border: InputBorder.none,
                        // //     labelText: "League",
                        // //     labelStyle: GoogleFonts.ubuntu(
                        // //       fontSize: 16,
                        // //       color: Colors.white,
                        // //       fontWeight: FontWeight.bold,
                        // //     ),
                        // //     hintText: "Select a League",
                        // //     hintStyle:
                        // //         GoogleFonts.montserrat(color: Colors.grey),
                        // //   ),
                        // //   autocorrect: true,
                        // //   autofocus: true,
                        // // ),
                        // // Container(
                        // //   color: Colors.white,
                        // //   child: DropDownField(
                        // //     //required: true,
                        // //     itemsVisibleInDropdown: 2,
                        // //     hintText: "Select League",
                        // //     hintStyle:
                        // //         GoogleFonts.montserrat(color: Colors.white),
                        // //     textStyle:
                        // //         GoogleFonts.montserrat(color: Colors.white),
                        // //     controller: widget.league,
                        // //     items: favLeagueList,
                        // //     onValueChanged: (value) {
                        // //       setState(() {
                        // //         selectedLeague = value;
                        // //       });
                        // //     },
                        // //   ),
                        // // ),
                        // FormField<String>(
                        //   builder: (FormFieldState<String> state) {
                        //     return InputDecorator(
                        //       decoration: InputDecoration(
                        //           filled: true,
                        //           fillColor: Colors.grey[900],
                        //           hintText: 'Please select League',
                        //           hintStyle: GoogleFonts.montserrat(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderRadius:
                        //                   BorderRadius.circular(5.0))),
                        //       //isEmpty: selectedLeague == '',
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //           dropdownColor: Colors.black,
                        //           iconEnabledColor: Colors.white,
                        //           style: GoogleFonts.rubik(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //           value: selectedLeague,
                        //           isDense: true,
                        //           onChanged: (String newValue) {
                        //             setState(() {
                        //               selectedLeague = newValue;
                        //               state.didChange(newValue);
                        //               print(selectedLeague);
                        //               //print(widget.league);
                        //             });
                        //           },
                        //           items: favLeagueList(),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
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
