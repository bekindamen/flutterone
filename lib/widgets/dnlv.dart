// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:url_launcher/url_launcher.dart';

class DNLV extends StatefulWidget {
  const DNLV({super.key});

  @override
  State<DNLV> createState() => _DNLVState();
}

class _DNLVState extends State<DNLV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                const GlowText(
                  'Latest version',
                  style: TextStyle(
                      fontSize: 38, color: Color.fromRGBO(255, 192, 245, 1)),
                ),
              ],
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.pink, Colors.pinkAccent])),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        'https://drive.google.com/file/d/1OEVSc2ExTlgNKKdFaN_yMFHzLIKnxFZN/view?usp=share_link'));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Click here to go to download page"),
                      Container(
                          height: 30, width: 30, child: Icon(Icons.download)),
                    ],
                  )),
            ],
          ),
        ));
  }
}
