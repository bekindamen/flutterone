// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_const, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutterone/widgets/addimgscreen.dart';
import 'package:flutterone/widgets/card.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class CurvedHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();

    var paint = Paint();
    paint.color = Colors.pink;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _MainscreenState extends State<Mainscreen> {
  bool urlgot = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String pp = '';

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

  // setparticulaarfalse(String code) {
  //   setState(() {
  //     if (code.contains('2')) {
  //       temp2 = false;
  //       temp1 = true;
  //     }
  //     if (code.contains('1')) {
  //       temp1 = false;
  //       temp2 = true;
  //     }
  //   });
  // }

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
      key: scaffoldKey,
      drawer: Drawer(
        elevation: 5,
        width: MediaQuery.of(context).size.width * 0.6,
        backgroundColor: Color.fromARGB(86, 255, 0, 187),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomPaint(
              painter: CurvedHeaderPainter(),
              child: DrawerHeader(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Color.fromARGB(213, 56, 21, 21),
                              spreadRadius: 0.5)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: urlgot ? CircularProgressIndicator() : null,
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
                      ))
                ]),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Container(
                child: const Text(
                  'Sign Out',
                  selectionColor: Colors.pink,
                  style: TextStyle(fontSize: 20),
                ),
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
                children: [],
              ))),
    );
  }
}
