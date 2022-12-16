// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_glow/flutter_glow.dart';

class AddImgScreen extends StatefulWidget {
  const AddImgScreen({super.key});

  @override
  State<AddImgScreen> createState() => _AddImgScreenState();
}

class _AddImgScreenState extends State<AddImgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GlowText(
                  'Add Image',
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
        ));
  }
}
