import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddPodcast extends StatefulWidget {
  const AddPodcast();

  @override
  _AddPodcastState createState() => _AddPodcastState();
}

class _AddPodcastState extends State<AddPodcast> {
  TextEditingController link = TextEditingController();
  TextEditingController cover = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            //bottom: 20,
            top: 20,
            left: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Podcasts 🎙️🔥",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              currentUser.isAdmin == true
                  ? IconButton(
                      splashRadius: 1,
                      splashColor: Colors.transparent,
                      color: Colors.white,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          backgroundColor: Colors.black,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade900,
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: TextFormField(
                                          controller: cover,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Podcast Cover',
                                            labelStyle: TextStyle(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade900,
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: TextFormField(
                                          controller: link,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Podcast Link',
                                            labelStyle: TextStyle(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        onPressed: () {
                                          HapticFeedback.mediumImpact();
                                          addPodcast();
                                        },
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.green),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Divider(
          indent: 10,
          endIndent: 30,
          color: Colors.grey.shade800,
          height: 15,
        ),
      ],
    );
  }

  String podID = Uuid().v4();
  addPodcast() async {
    FirebaseFirestore.instance.collection("Podcasts").doc(podID).set({
      "link": link.text,
      "cover": cover.text,
      "id": podID,
    }).whenComplete(() {
      setState(() {
        link.clear();
        cover.clear();
        podID = Uuid().v4();
      });
    });
  }
}
