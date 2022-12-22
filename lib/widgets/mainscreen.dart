// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_const, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutterone/widgets/addimgscreen.dart';
import 'package:flutterone/widgets/dnlv.dart';
import 'package:flutterone/widgets/samlls/open.dart';
import 'package:flutterone/widgets/settings.dart' as myset;
import 'package:http/http.dart' as http;

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
  bool isDA = false;
  String? age;
  

  getlinkbyage() async {
    var resage = await http.get(Uri.parse('http://54.234.140.51:800/api/personaldata'));
    Map<String, dynamic> mapage = jsonDecode(resage.body.toString());
    String age = mapage['data']['age'].toString();
    print(age);
        var res3 = await http.get(
      Uri.parse('http://54.234.140.51:8000/api/ages/21' ),
    );
   
     Map<String, dynamic> map = jsonDecode(res3.body.toString()); 
     
     List<dynamic> map2 = map['data']['images'];
     map2.forEach((e) {
       var map4 = jsonEncode(e);
       var map3 = jsonDecode(map4);
        String id = map3['_id'];
        String link = map3['link'];
widlist.add(GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Opened(
                url: link, id: id,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return CupertinoPageTransition(
                  linearTransition: true,
                  primaryRouteAnimation: animation,
                  secondaryRouteAnimation: secondaryAnimation,
                  child: child,
                );
              },
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            shadowColor: Colors.black,
            elevation: 10,
            color: Color.fromARGB(99, 0, 0, 0),
            child: Hero(
              tag: link,
              child: Image(image: Image.network(link).image),
            ),
          ),
        ),
      ),
    ));
     });
      }

   

  List<Widget> widlist = [
   
     
  ];

  Future<String> geturl() async {
    var resp =
        await http.get(Uri.parse('http://54.234.140.51:8000/api/constatus/2'));
    if (resp.body.toString().contains('true'))
      setState(() {
        isDA = true;
      });
    FirebaseMessaging messaging = await FirebaseMessaging.instance;

    await FirebaseMessaging.instance.subscribeToTopic("downloadupdate");

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

  late PageController _pageController;
  int cuur = 0;

  @override
  void initState() {

    FirebaseMessaging.onMessage.listen((event) {});

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DNLV(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  widlist = [];
    super.initState();
    getlinkbyage();
    _pageController = PageController(initialPage: cuur, viewportFraction: 0.8);
 
    widlist.add(GestureDetector(
      
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Opened(
                url: 'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/happrbubbling.png?alt=media&token=1886f19c-4441-49f9-98d9-47a0b96ceef6', id: 'welcome',
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return CupertinoPageTransition(
                  linearTransition: true,
                  primaryRouteAnimation: animation,
                  secondaryRouteAnimation: secondaryAnimation,
                  child: child,
                );
              },
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            shadowColor: Colors.black,
            elevation: 10,
            color: Color.fromARGB(99, 0, 0, 0),
            child: Hero(
              tag: 'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/happrbubbling.png?alt=media&token=1886f19c-4441-49f9-98d9-47a0b96ceef6',
              child: Image(image: Image.network('https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/happrbubbling.png?alt=media&token=1886f19c-4441-49f9-98d9-47a0b96ceef6').image),
            ),
          ),
        ),
      ),
    ));

    
  }


  @override
  void dispose(){
    
    _pageController.dispose();
    super.dispose();

  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      drawer: Drawer(
        elevation: 4,
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
                    child: FutureBuilder<String>(
                        future: urlgot ? geturl() : null,
                        builder: ((context, snapshot) {
                          return CircleAvatar(
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
                                  SnackBar(
                                      content:
                                          Text('Slow internet connection')));
                            },
                          );
                        })),
                  )
                ]),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            myset.MySettings(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.settings,
                    color: Color.fromARGB(146, 255, 255, 255),
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                        color: Color.fromARGB(255, 46, 210, 255),
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 50,
                          ),
                          Shadow(color: Colors.grey, blurRadius: 5),
                          Shadow(color: Colors.pink, blurRadius: 5),
                          Shadow(color: Colors.blue, blurRadius: 5),
                        ]),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DNLV(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.settings,
                    color: Color.fromARGB(153, 255, 255, 255),
                  ),
                  title: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Download latest version',
                        style: TextStyle(
                            color: Color.fromARGB(255, 46, 210, 255),
                            fontSize: 15,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 50,
                              ),
                              Shadow(color: Colors.grey, blurRadius: 5),
                              Shadow(color: Colors.pink, blurRadius: 5),
                              Shadow(color: Colors.blue, blurRadius: 5),
                            ]),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent),
                          alignment: Alignment.center,
                          child: isDA
                              ? CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.download_rounded))
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: Container(
                child: const Text(
                  'Sign Out',
                  selectionColor: Colors.pink,
                  style: TextStyle(fontSize: 18, color: Colors.grey, shadows: [
                    Shadow(color: Colors.black, blurRadius: 6),
                    Shadow(color: Colors.grey, blurRadius: 2),
                    Shadow(color: Colors.pink, blurRadius: 4),
                    Shadow(color: Colors.blue, blurRadius: 5),
                  ]),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 25, 0),
                        child: GlowContainer(
                            blurRadius: 4,
                            spreadRadius: 2,
                            shape: BoxShape.circle,
                            glowColor: Color.fromARGB(255, 75, 180, 182),
                            animationDuration: Duration(milliseconds: 500),
                            animationCurve: Curves.easeIn,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        AddImgScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
                                child:
                                    urlgot ? CircularProgressIndicator() : null,
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AspectRatio(
                    aspectRatio: (300 / 367),
                    child: PageView.builder(
                        itemCount: widlist.length,
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index.toDouble() - (_pageController.page ?? 0);
            value = (value * 0.038).clamp(-1, 1);
          }
          return Transform.rotate(
              angle: (22 / 7) * value, child: widlist[index]);
        });
                        }),
                  ),
                  TextButton(child: Text('data'), onPressed: getlinkbyage,)
                ],
              ))),
    );
  }
}
