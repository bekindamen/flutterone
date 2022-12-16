// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutterone/widgets/loginavatar.dart';

class AddImgScreen extends StatefulWidget {
  const AddImgScreen({super.key});

  @override
  State<AddImgScreen> createState() => _AddImgScreenState();
}

class _AddImgScreenState extends State<AddImgScreen> {
  bool _buttonClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              const GlowText(
                'Add Image',
                style: TextStyle(
                    fontSize: 38, color: Color.fromRGBO(255, 192, 245, 1)),
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
          child: Column(children: [
            SizedBox(
              height: 130,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    width: _buttonClicked ? 310 : 300,
                    height: _buttonClicked ? 105 : 100,
                    decoration: _buttonClicked
                        ? BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.pink,
                                  spreadRadius: 2)
                            ],
                          )
                        : null,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _buttonClicked = !_buttonClicked;
                          });
                          Future.delayed(Duration(milliseconds: 100))
                              .then((value) {
                            setState(() {
                              _buttonClicked = !_buttonClicked;
                            });
                          });
                          Avatar();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color.fromARGB(159, 0, 0, 0),
                                  Color.fromARGB(255, 255, 82, 226)
                                ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft)),
                            child: Center(
                              child: Text(
                                'Add new image',
                                style: TextStyle(fontSize: 27),
                              ),
                            ),
                          ),
                        )),
                  ),
                )
              ],
            )
          ]),
        ));
  }
}
