import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatefulWidget {
  final String Name;

  const AddEvent({Key key, this.Name}) : super(key: key);
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String _selectedName1;
  String _selectedImage1;
  String _selectedName2;
  String _selectedImage2;
  bool isLocked = false;
  String ID = Uuid().v4();
  List<Map> ISLteamNames = [
    {
      "id": '1',
      "image": "https://www.fotmob.com/images/team/578655",
      "name": "Mumbai City FC",
    },
    {
      "id": '2',
      "image": "https://www.fotmob.com/images/team/578656",
      "name": "NortEast United FC",
    },
    {
      "id": '3',
      "image": "https://www.fotmob.com/images/team/578651",
      "name": "ATK Mohun Bagan FC",
    },
    {
      "id": '4',
      "image": "https://www.fotmob.com/images/team/485935",
      "name": "Bengaluru FC",
    },
    {
      "id": '5',
      "image": "https://www.fotmob.com/images/team/578650",
      "name": "FC Goa",
    },
    {
      "id": '6',
      "image": "https://www.fotmob.com/images/team/1086744",
      "name": "Hyderabad FC",
    },
    {
      "id": '7',
      "image": "https://www.fotmob.com/images/team/873038",
      "name": "Jamshedpur FC",
    },
    {
      "id": '8',
      "image": "https://www.fotmob.com/images/team/578652",
      "name": "Chennaiyin FC",
    },
    {
      "id": '9',
      "image": "https://www.fotmob.com/images/team/578654",
      "name": "Kerala Blasters FC",
    },
    {
      "id": '10',
      "image": "https://www.fotmob.com/images/team/578653",
      "name": "Odisha FC",
    },
    {
      "id": '11',
      "image": "https://www.fotmob.com/images/team/165184",
      "name": "SC East Bengal",
    },
  ];

  List<Map> ILeagueteamNames = [
    {
      "id": '1',
      "image": "https://www.fotmob.com/images/team/624350",
      "name": "Aizawl FC",
    },
    {
      "id": '2',
      "image": "https://www.fotmob.com/images/team/818233",
      "name": "Chennai City FC",
    },
    {
      "id": '3',
      "image": "https://www.fotmob.com/images/team/165180",
      "name": "Churchill Brothers",
    },
    {
      "id": '4',
      "image": "https://www.fotmob.com/images/team/898335",
      "name": "Gokulam FC",
    },
    {
      "id": '5',
      "image": "https://www.fotmob.com/images/team/231168",
      "name": "Indian Arrows",
    },
    {
      "id": '6',
      "image": "https://www.fotmob.com/images/team/165187",
      "name": "Mohammedan SC",
    },
    {
      "id": '7',
      "image": "https://www.fotmob.com/images/team/898338",
      "name": "Neroca FC",
    },
    {
      "id": '8',
      "image": "https://www.fotmob.com/images/team/589749",
      "name": "Punjab FC",
    },
    {
      "id": '9',
      "image": "https://www.fotmob.com/images/team/970686",
      "name": "Real Kashmir FC",
    },
    {
      "id": '10',
      "image": "https://www.fotmob.com/images/team/1215010",
      "name": "Sudeva FC",
    },
    {
      "id": '11',
      "image": "https://www.fotmob.com/images/team/1111274",
      "name": "TRAU FC",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  isDense: true,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  hint: Text(
                    "Select Team 1",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _selectedName1,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedName1 = newValue;
                    });
                  },
                  items: widget.Name == "ISLPrediction"
                      ? ISLteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["name"],
                            // value: _mySelection,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                map["name"],
                              ),
                            ),
                          );
                        }).toList()
                      : ILeagueteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["name"],
                            // value: _mySelection,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                map["name"],
                              ),
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  isDense: true,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  hint: Text(
                    "Select Team 1 Logo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _selectedImage1,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedImage1 = newValue;
                    });
                  },
                  items: widget.Name == "ISLPrediction"
                      ? ISLteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["image"],
                            // value: _mySelection,
                            child: CachedNetworkImage(
                              imageUrl: map["image"],
                              width: 25,
                            ),
                          );
                        }).toList()
                      : ILeagueteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["image"],
                            // value: _mySelection,
                            child: CachedNetworkImage(
                              imageUrl: map["image"],
                              width: 25,
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  isDense: true,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  hint: Text(
                    "Select Team 2",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _selectedName2,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedName2 = newValue;
                    });
                  },
                  items: widget.Name == "ISLPrediction"
                      ? ISLteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["name"],
                            // value: _mySelection,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                map["name"],
                              ),
                            ),
                          );
                        }).toList()
                      : ILeagueteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["name"],
                            // value: _mySelection,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                map["name"],
                              ),
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  isDense: true,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  hint: Text(
                    "Select Team 2 Logo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _selectedImage2,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedImage2 = newValue;
                    });
                  },
                  items: widget.Name == "ISLPrediction"
                      ? ISLteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["image"],
                            // value: _mySelection,
                            child: CachedNetworkImage(
                              imageUrl: map["image"],
                              width: 25,
                            ),
                          );
                        }).toList()
                      : ILeagueteamNames.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["image"],
                            // value: _mySelection,
                            child: CachedNetworkImage(
                              imageUrl: map["image"],
                              width: 25,
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
            FlatButton(
              color: Colors.white,
              onPressed: () {
                HapticFeedback.mediumImpact();
                saveToDatabase();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  saveToDatabase() {
    FirebaseFirestore.instance.collection(widget.Name).doc(ID).set({
      "Id": ID,
      "ownerID": currentUser.id,
      "timestamp": DateTime.now(),
      "name": currentUser.username,
      "team1Name": _selectedName1,
      "team1Logo": _selectedImage1,
      "team2Name": _selectedName2,
      "team2Logo": _selectedImage2,
      "status": isLocked,
      "usersVoted": [],
    }).then((result) {
      Navigator.pop(context);
      setState(() {
        ID = Uuid().v4();
      });
    });
  }
}
