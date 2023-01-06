// ignore_for_file: prefer_const_constructors
// ignore_for_file: use_key_in_widget_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io'; 
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterone/conncheck.dart';


import 'package:flutterone/widgets/emailverify.dart';
import 'package:flutterone/widgets/loading.dart';
import 'package:flutterone/widgets/login.dart';
import 'package:flutterone/widgets/mainscreen.dart';
import 'package:flutterone/widgets/samlls/bubble.dart';

 

Future main() async {
 
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
 FlutterNativeSplash.remove();

  runApp(MyApp());
}


bool tomain = false;

class MyApp extends StatelessWidget {
 
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'Cedric', backgroundColor: Colors.transparent),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: !tomain
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bubble(),
                      const GlowText(
                        'Bubble',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                            fontSize: 38,
                            color: Color.fromRGBO(255, 192, 245, 1)),
                      ),
                    ],
                  ))
              : null,
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.redAccent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      setState() {
                        tomain = true;
                      }

                      return Mainscreen();
                    } else {
                      return VerifyEmail();
                    }
                  }
                  return Login();
                })),
          ),
        ));
  }
}
