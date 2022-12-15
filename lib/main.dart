// ignore_for_file: prefer_const_constructors
// ignore_for_file: use_key_in_widget_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutterone/widgets/emailverify.dart';
import 'package:flutterone/widgets/home.dart';
import 'package:flutterone/widgets/login.dart';
import 'package:flutterone/widgets/mainscreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'Cedric', backgroundColor: Colors.transparent),
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GlowText(
                    'Bubble',
                    style: TextStyle(
                        fontSize: 38, color: Color.fromRGBO(255, 192, 245, 1)),
                  ),
                ],
              )),
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
                      return Mainscreen();
                    } else
                      return VerifyEmail();
                  }
                  return Login();
                })),
          ),
        ));
  }
}
