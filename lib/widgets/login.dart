// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterone/widgets/emailverify.dart';
import 'package:flutterone/widgets/home.dart';
import 'package:flutterone/widgets/loginavatar.dart';
import 'package:flutterone/widgets/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var logIn = true;
  bool loading = false;
  String email = '';
  String phone = '';
  String password = '';
  bool emailVerify = false;

  void signUp() async {
    try {
      if (AvatarState.imagepicked == true) {
        if (emailVerify) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Verify email please.')));
          return;
        }

        setState(() {
          loading = true;
        });
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('dp')
            .child(userCredential.user!.uid + '.jpg');
        File imagePicked = File((AvatarState.pickedImage)!.path);
        await ref.putFile(imagePicked);

        final dpurl = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'phone': phone, 'dpUrl': dpurl});

        final response = await http.post(
          Uri.parse('http://54.234.140.51:8000/api/personalData/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            '_id': userCredential.user!.uid,
            'phone': phone,
            'email': FirebaseAuth.instance.currentUser!.email,
            'emailVerified': false,
          }),
        );

        if (response.statusCode == 201) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
        }

        setState(() {
          emailVerify = true;
          loading = false;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please pick an image.')));
      }
    } catch (err) {
      setState(() {
        loading = false;
      });
      if (err.toString().contains('email-already-in-use')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Already signed up. Please sign in rather.')));
      }
    }
  }

  void signIn() async {
    try {
      setState(() {
        loading = true;
      });
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => VerifyEmail())));
        return;
      }
      setState(() {
        loading = false;
      });
    } catch (err) {
      setState(() {
        loading = false;
      });
      if (err.toString().contains('user-not-found')) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found. Please sign up. ')));
      }

      if (err.toString().contains('wrong-password')) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wrong password. Please try again.')));
      }
    }
  }

  void resetpass() {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!logIn) Avatar(),
                  if (loading)
                    Container(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) => value.toString().contains('@')
                        ? null
                        : 'Invalid email number',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    obscureText: false,
                    onSaved: (value) => email = value.toString(),
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) => value.toString().length < 8 ||
                            RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value.toString())
                        ? 'Password must be atleast 8 characters and include \nnumber and upper and lower case letters'
                        : null,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) => password = value.toString(),
                  ),
                  const SizedBox(height: 12),
                  if (!logIn)
                    TextFormField(
                      key: const ValueKey('phone'),
                      validator: (value) => value.toString().trim().length != 10
                          ? 'Invalid phone number (don\'t include +91).'
                          : null,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      decoration:
                          const InputDecoration(labelText: 'Phone number'),
                      obscureText: false,
                      onSaved: (value) => phone = value.toString(),
                    ),
                  const SizedBox(height: 12),
                  GlowButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _formKey.currentState!.save();
                          logIn ? signIn() : signUp();
                        }
                      },
                      child: Text(logIn ? 'Sign in' : 'Sign up')),
                  const SizedBox(height: 12),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          logIn = !logIn;
                        });
                      },
                      child: Text(logIn
                          ? 'Create new account'
                          : 'I already have an account')),
                  logIn
                      ? TextButton(
                          onPressed: resetpass, child: Text('Forgot password!'))
                      : Container(),
                  emailVerify ? VerifyEmail() : Container(),
                ],
              )),
        )),
      ),
    );
  }
}
