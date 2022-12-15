// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutterone/widgets/mainscreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Mainscreen(),
    );
  }
}
