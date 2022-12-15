import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterone/widgets/mainscreen.dart';
import 'package:http/http.dart' as http;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;

  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        checkEmailVerified();
      });
    }
  }

  void resendEmail() {
    sendVerificationEmail();
  }

  Future<void> emailVerified() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final response = await http.put(
      Uri.parse('http://54.234.140.51:8000/api/personalData/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, bool>{
        'emailVerified': true,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      await emailVerified();
      dispose();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 20,
                            color: Color.fromARGB(215, 188, 137, 206),
                            spreadRadius: 7)
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      backgroundImage: Image.network(
                              'https://img.freepik.com/free-photo/studio-background-concept-abstract-empty-light-gradient-purple-studio-room-background-product-plain-studio-background_1258-54492.jpg?w=900&t=st=1668051847~exp=1668052447~hmac=e157c49cdd2e533933f2549e41b7d4e9b3ea5e6640c5ee8be540e6e805186663')
                          .image,
                    ),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 1, 1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Color.fromARGB(255, 182, 144, 181),
                        spreadRadius: 5)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  backgroundImage: Image.network(
                          'https://img.freepik.com/free-photo/studio-background-concept-abstract-empty-light-gradient-purple-studio-room-background-product-plain-studio-background_1258-54492.jpg?w=900&t=st=1668051847~exp=1668052447~hmac=e157c49cdd2e533933f2549e41b7d4e9b3ea5e6640c5ee8be540e6e805186663')
                      .image,
                ),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: Color.fromARGB(255, 190, 152, 196),
                    spreadRadius: 10)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 190,
              backgroundImage: Image.network(
                      'https://img.freepik.com/free-photo/studio-background-concept-abstract-empty-light-gradient-purple-studio-room-background-product-plain-studio-background_1258-54492.jpg?w=900&t=st=1668051847~exp=1668052447~hmac=e157c49cdd2e533933f2549e41b7d4e9b3ea5e6640c5ee8be540e6e805186663')
                  .image,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(96, 255, 255, 255),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  color: Color.fromARGB(255, 190, 152, 196),
                                  spreadRadius: 10)
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Color.fromARGB(96, 255, 255, 255),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 255, 255),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Color.fromARGB(255, 190, 152, 196),
                                    spreadRadius: 10)
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Color.fromARGB(96, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 255, 255),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Color.fromARGB(255, 190, 152, 196),
                                    spreadRadius: 10)
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Color.fromARGB(96, 255, 255, 255),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(96, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 240, 227, 227)
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          )
                        ]),
                    alignment: Alignment.center,
                    child: const Text(
                      'Verify you Email.',
                      style: TextStyle(
                        fontSize: 30,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 93, 68, 68),
                          ),
                          Shadow(
                            blurRadius: 8.0,
                            color: Color.fromARGB(123, 255, 255, 255),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      onPressed: resendEmail,
                      child: Text(
                        'Resend email for verification',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black26),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
