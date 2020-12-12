import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddPollPage extends StatefulWidget {
  final String route;
  final List<dynamic> tags;
  const AddPollPage({Key key, this.route, this.tags}) : super(key: key);
  @override
  _AddPollPageState createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  String postId = Uuid().v4();
  bool uploading = false;
  bool isTop25 = false;
  String tag = "Off topic";
  TextEditingController question = TextEditingController();
  TextEditingController option1 = TextEditingController();
  TextEditingController option2 = TextEditingController();
  TextEditingController option3 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isTyping = false;

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Banner(
        location: BannerLocation.topEnd,
        message: 'Beta',
        child: Scaffold(
          backgroundColor: Color(0xFF0e0e10),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      uploading ? LinearProgressIndicator() : Text(""),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Container(
                                child: TextFormField(
                                  onChanged: (_) {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  controller: question,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Question cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "Add your question here...",
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 2.0),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: GoogleFonts.averageSans(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Container(
                                child: TextFormField(
                                  controller: option1,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Options cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "Add your option 1 here...",
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 2.0),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: GoogleFonts.averageSans(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Container(
                                child: TextFormField(
                                  controller: option2,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Options cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "Add your option 2 here...",
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 2.0),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: GoogleFonts.averageSans(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Container(
                                child: TextFormField(
                                  controller: option3,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "Add your option 3 (optional)",
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 2.0),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: GoogleFonts.averageSans(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ),
                            ),
                            Container(
                              child: DropdownButtonFormField(
                                dropdownColor: Color(0xFF0e0e10),
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                ),
                                value: tag ?? "Off topic",
                                onChanged: (val) {
                                  setState(() {
                                    tag = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF0e0e10),
                                  border: InputBorder.none,
                                  labelText: "Pick a tag",
                                  labelStyle: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                items: widget.tags.map((team) {
                                  return DropdownMenuItem(
                                    child: Text("$team"),
                                    value: team,
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  savePollToDatabase();
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: isTyping == true
                                        ? LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              Color(0xff8134AF),
                                              Color(0xff515BD4),
                                            ],
                                          )
                                        : LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              Colors.grey[700],
                                              Colors.grey[800],
                                            ],
                                          ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Post Poll",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              uploading
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    savePollToDatabase();
  }

  savePollToDatabase() {
    FirebaseFirestore.instance
        .collection("Forum")
        .doc(widget.route)
        .collection("Polls")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "usersVoted": [],
      "question": question.text,
      "option1": option1.text,
      "option1Votes": 0,
      "option2": option2.text,
      "option2Votes": 0,
      "option3": option3.text,
      "option3Votes": 0,
      "userPic": currentUser.url,
      "isVerified": currentUser.isVerified,
      "tags": tag,
      "top25": isTop25,
      "likes": [],
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        uploading = false;
        postId = Uuid().v4();
        question.clear();
        option1.clear();
        option2.clear();
        option3.clear();
        postId = Uuid().v4();
      });
    });
  }
}
