import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/home.dart';
import 'package:uuid/uuid.dart';

class PlayerVotes extends StatefulWidget {
  @override
  _PlayerVotesState createState() => _PlayerVotesState();
}

class _PlayerVotesState extends State<PlayerVotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController option1Name = TextEditingController();
  TextEditingController option2Name = TextEditingController();
  TextEditingController option1Image = TextEditingController();
  TextEditingController option2Image = TextEditingController();
  TextEditingController bgImage = TextEditingController();
  String postId = Uuid().v4();

  uploadToFirestore() async {
    var currentId = currentUser.id;
    votesReference.doc(postId).set({
      "username": currentUser.username,
      "uid": currentId,
      "postID": postId,
      "profilePic": currentUser.url,
      "likes1Option": [],
      "likes2Option": [],
      "title": titleController.text,
      "option1Name": option1Name.text,
      "option2Name": option2Name.text,
      "option1Image": option1Image.text,
      "option2Image": option2Image.text,
      "backgroundImage": bgImage.text,
      "timeStamap": DateTime.now(),
    }).whenComplete(() {
      setState(() {
        titleController.clear();
        option1Name.clear();
        option2Name.clear();
        option1Image.clear();
        option2Image.clear();
        postId = Uuid().v4();
        Navigator.pop(context);
      });
    });
  }

  Stream voteStream;
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );

  @override
  void initState() {
    super.initState();
    voteStream =
        votesReference.orderBy("timeStamap", descending: true).snapshots();
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0e0e10),
      floatingActionButton: currentUser.isAdmin == true
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              decoration:
                                  const InputDecoration(labelText: 'Title'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: option1Name,
                              decoration: const InputDecoration(
                                  labelText: 'Option 1 name'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: option2Name,
                              decoration: const InputDecoration(
                                  labelText: 'Option 2 Name'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: option1Image,
                              decoration: const InputDecoration(
                                  labelText: 'Option 1 url'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: option2Image,
                              decoration: const InputDecoration(
                                  labelText: 'Option 2 url'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: bgImage,
                              decoration: const InputDecoration(
                                  labelText: 'Background Image'),
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Please enter some text';
                                return null;
                              },
                            ),
                            RaisedButton(
                              onPressed: () => uploadToFirestore(),
                              child: Text("Submit"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const SizedBox.expand(),
      body: StreamBuilder(
          stream: voteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot votes = snapshot.data.docs[index];
                  return Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.15),
                                BlendMode.dstATop),
                            image: CachedNetworkImageProvider(
                              votes.data()["backgroundImage"],
                            ),
                          ),
                        ),
                        child: Column(
                          //shrinkWrap: true,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 14.0,
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Text(
                                    votes.data()["title"],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey[800],
                              //thickness: 0.5,
                              //height: 1,
                              indent: 50,
                              endIndent: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        votes.data()["option1Name"],
                                        style: GoogleFonts.rubik(
                                          color: Colors.grey[300],
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              votes.data()["option1Image"],
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Ionicons.ios_arrow_up,
                                          color: votes
                                                  .data()["likes1Option"]
                                                  .contains(currentUser.id)
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          HapticFeedback.mediumImpact();
                                          likeOption1(
                                            votes.data()["postID"],
                                          );
                                        },
                                      ),
                                      Text(
                                        votes
                                            .data()["likes1Option"]
                                            .length
                                            .toString(),
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        votes.data()["option2Name"],
                                        style: GoogleFonts.rubik(
                                          color: Colors.grey[300],
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              votes.data()["option2Image"],
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Ionicons.ios_arrow_up,
                                          color: votes
                                                  .data()["likes2Option"]
                                                  .contains(currentUser.id)
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          HapticFeedback.mediumImpact();
                                          likeOption2(
                                            votes.data()["postID"],
                                          );
                                        },
                                      ),
                                      Text(
                                        votes
                                            .data()["likes2Option"]
                                            .length
                                            .toString(),
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      currentUser.isAdmin == true
                          ? Positioned(
                              top: 50,
                              right: 15,
                              child: FloatingActionButton(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  removeBattle(
                                    votes.data()["postID"],
                                  );
                                },
                              ),
                            )
                          : const SizedBox.expand(),
                    ],
                  );
                });
          }),
    );
  }

  removeBattle(String id) async {
    await votesReference.doc(id).get().then((docs) {
      if (docs.exists) {
        docs.reference.delete();
      }
    });
  }

  likeOption1(String id) async {
    DocumentSnapshot docs = await votesReference.doc(id).get();
    if (docs.data()['likes1Option'].contains(currentUser.id)) {
      votesReference.doc(id).update({
        'likes1Option': FieldValue.arrayRemove(
          [currentUser.id],
        )
      });
    } else {
      votesReference.doc(id).update({
        'likes1Option': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }

  likeOption2(String id) async {
    DocumentSnapshot docs = await votesReference.doc(id).get();
    if (docs.data()['likes2Option'].contains(currentUser.id)) {
      votesReference.doc(id).update({
        'likes2Option': FieldValue.arrayRemove([currentUser.id])
      });
    } else {
      votesReference.doc(id).update({
        'likes2Option': FieldValue.arrayUnion([currentUser.id])
      });
    }
  }
}
