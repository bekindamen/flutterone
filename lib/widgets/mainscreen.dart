// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_const, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutterone/widgets/card.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  bool urlgot = true, temp1 = true, temp2 = true, temp3 = true;
  var temp = true;

  var pp = '';

  Future<String> geturl() async {
    final dpUrl = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await dpUrl.get();

    snapshot.data()!.forEach((key, value) {
      if (key == 'dpUrl') {
        setState(() {
          pp = value.toString();
          urlgot = true;
        });
        return value;
      }
    });
    setState(() {
      urlgot = false;
    });
    return 'error';
  }

  double _rating = 0;

  setparticulaarfalse(String code) {
    setState(() {
      if (code.contains('2')) {
        temp2 = false;
        temp1 = true;
      }
      if (code.contains('1')) {
        temp1 = false;
        temp2 = true;
      }
    });
  }

  List<String> imagelist = [
    'https://s2.best-wallpaper.net/wallpaper/iphone/1902/Beautiful-girl-in-summer-sunshine_iphone_1242x2688.jpg',
    'https://iphoneswallpapers.com/wp-content/uploads/2016/12/girl-model-beauty-look-iPhone-Wallpaper-iphoneswallpapers_com.jpg',
    'https://mobimg.b-cdn.net/v3/fetch/5a/5ad87300ab0936e7be3ce39a6c404954.jpeg?h=900&r=0.5'
  ];

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.fromARGB(86, 255, 0, 187),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pink, Colors.redAccent],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                temp
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: CircularProgressIndicator(),
                          backgroundImage: !urlgot
                              ? Image.network(pp).image
                              : Image.asset('res/no-profile-picture-icon.png')
                                  .image,
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              urlgot = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(exception.toString())));
                          },
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6,
                                color: Color.fromARGB(95, 0, 0, 0),
                                spreadRadius: 4)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey,
                          backgroundImage: !urlgot
                              ? Image.network(pp).image
                              : Image.asset('res/no-profile-picture-icon.png')
                                  .image,
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              urlgot = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(exception.toString())));
                          },
                        ),
                      ),
              ]),
            ),
            ListTile(
              title: const Text(
                'Sign Out',
                selectionColor: Colors.white,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.redAccent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        temp
                            ? FutureBuilder<String>(
                                future: geturl(),
                                builder: ((context, snapshot) {
                                  geturl().then((value) {
                                    setState(() {
                                      temp = false;
                                    });
                                  });
                                  return CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: CircularProgressIndicator(),
                                    backgroundImage: !urlgot
                                        ? Image.network(pp).image
                                        : Image.asset(
                                                'res/no-profile-picture-icon.png')
                                            .image,
                                    onBackgroundImageError:
                                        (exception, stackTrace) {
                                      setState(() {
                                        urlgot = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text(exception.toString())));
                                    },
                                  );
                                }))
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
                                backgroundImage: !urlgot
                                    ? Image.network(pp).image
                                    : Image.asset(
                                            'res/no-profile-picture-icon.png')
                                        .image,
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  setState(() {
                                    urlgot = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(exception.toString())));
                                },
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            //do some
                          },
                          child: Text("Superlike")),
                      ElevatedButton(
                          onPressed: () {
                            //do some
                          },
                          child: Text("Like"))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Stack(children: [
                          temp1
                              ? LongPressDraggable<Column>(
                                  childWhenDragging: Container(
                                    height: 100,
                                    width: 100,
                                  ),
                                  feedback: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 6,
                                                color:
                                                    Color.fromARGB(95, 0, 0, 0),
                                                spreadRadius: 4)
                                          ]),
                                      child:
                                          TinderLikeCard(color: imagelist[1])),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 6,
                                                      color: Color.fromARGB(
                                                          95, 0, 0, 0),
                                                      spreadRadius: 6)
                                                ]),
                                            child: TinderLikeCard(
                                                color: imagelist[1])),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 6,
                                                  color: Color.fromARGB(
                                                      95, 0, 0, 0),
                                                  spreadRadius: 4)
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Container(
                                            color: Colors.white,
                                            height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            child: Row(children: [
                                              SizedBox(
                                                width: 40,
                                              ),
                                              RatingBar.builder(
                                                initialRating: 0,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, index) {
                                                  switch (index) {
                                                    case 0:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_dissatisfied,
                                                        color: Colors.red,
                                                      );
                                                    case 1:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_dissatisfied,
                                                        color: Colors.redAccent,
                                                      );
                                                    case 2:
                                                      return Icon(
                                                        Icons.sentiment_neutral,
                                                        color: Colors.amber,
                                                      );
                                                    case 3:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_satisfied,
                                                        color:
                                                            Colors.lightGreen,
                                                      );
                                                    case 4:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_satisfied,
                                                        color: Colors.green,
                                                      );
                                                    default:
                                                      return Container();
                                                  }
                                                },
                                                onRatingUpdate: (rating) {
                                                  setparticulaarfalse('1');
                                                  setState(() {
                                                    _rating = rating;
                                                  });
                                                },
                                                updateOnDrag: true,
                                              )
                                            ]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                              : Container(),
                          temp2
                              ? LongPressDraggable<Column>(
                                  childWhenDragging: Container(
                                    height: 100,
                                    width: 100,
                                  ),
                                  feedback: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 6,
                                                color:
                                                    Color.fromARGB(95, 0, 0, 0),
                                                spreadRadius: 4)
                                          ]),
                                      child:
                                          TinderLikeCard(color: imagelist[0])),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 6,
                                                      color: Color.fromARGB(
                                                          95, 0, 0, 0),
                                                      spreadRadius: 6)
                                                ]),
                                            child: TinderLikeCard(
                                                color: imagelist[0])),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 6,
                                                  color: Color.fromARGB(
                                                      95, 0, 0, 0),
                                                  spreadRadius: 4)
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Container(
                                            color: Colors.white,
                                            height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            child: Row(children: [
                                              SizedBox(
                                                width: 40,
                                              ),
                                              RatingBar.builder(
                                                initialRating: 0,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, index) {
                                                  switch (index) {
                                                    case 0:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_dissatisfied,
                                                        color: Colors.red,
                                                      );
                                                    case 1:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_dissatisfied,
                                                        color: Colors.redAccent,
                                                      );
                                                    case 2:
                                                      return Icon(
                                                        Icons.sentiment_neutral,
                                                        color: Colors.amber,
                                                      );
                                                    case 3:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_satisfied,
                                                        color:
                                                            Colors.lightGreen,
                                                      );
                                                    case 4:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_satisfied,
                                                        color: Colors.green,
                                                      );
                                                    default:
                                                      return Container();
                                                  }
                                                },
                                                onRatingUpdate: (rating) {
                                                  setparticulaarfalse('2');
                                                  setState(() {
                                                    _rating = rating;
                                                  });
                                                },
                                                updateOnDrag: true,
                                              )
                                            ]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                              : Container(),
                        ]),
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
