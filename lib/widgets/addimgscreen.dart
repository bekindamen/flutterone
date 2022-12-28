// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterone/widgets/samlls/imagebuilder.dart';
import 'package:flutterone/widgets/samlls/listimages.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:http/http.dart' as http;
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
    setState(() {
      AvatarState.imagepicked = false;
      AvatarState.pickedImage = null;
    });
  }

  String genuuid() {
    final uuid = Uuid();
    return uuid.v4();
  }

  Future<List<String>> getlinks() async {
    List<String> mylist = [];

    String uid = FirebaseAuth.instance.currentUser!.uid;
    var res = await http
        .get(Uri.parse('http://54.234.140.51:8000/api/personaldata/' + uid));
    Map<String, dynamic> map = jsonDecode(res.body.toString());
    List<dynamic> images = map['data']['images'];
    for (var image in images) {
      mylist.add(image['link']);
    }
    return mylist;
  }

  bool loading = false;
  Future<void> submit() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    File imagePicked = File((AvatarState.pickedImage)!.path);

    var uuid = genuuid();
    setState(() {
      loading = true;
    });
    String imgurl = '';
    try {
      final ref = FirebaseStorage.instance.ref().child(uuid + '.jpg');
      await ref.putFile(imagePicked);
      imgurl = await ref.getDownloadURL();
      Map<String, String> bodydata = <String, String>{
        '_id': uid,
        'link': imgurl
      };
      var push = await http.get(Uri.parse('http://54.234.140.51:8082'));

      Map<String, Map<String, Map<String, String>>> bodydata1 =
          <String, Map<String, Map<String, String>>>{
        push.body.toString(): {
          "images": {"link": imgurl}
        }
      };
      var res1 = await http.put(
        Uri.parse('http://54.234.140.51:8000/api/personaldata/' + uid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bodydata1),
      );
      var resage = await http.get(Uri.parse(
          'http://54.234.140.51:8000/api/personaldata/' +
              FirebaseAuth.instance.currentUser!.uid));
      Map<String, dynamic> map = jsonDecode(resage.body.toString());
      int age = int.parse(map['data']['age']);
      
      var res = await http.put(
        Uri.parse('http://54.234.140.51:8000/api/age/' + age.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bodydata),
      );
      setState(() {
        AvatarState.imagepicked = false;
        AvatarState.pickedImage = null;
        loading = false;
      });
    } catch (err) {
      AlertDialog(
        title: Text(err.toString()),
      );
    }
  }
   

  bool openavatar = false;

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
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.redAccent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  openavatar = !openavatar;
                                });
                              });
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
                ),
                SizedBox(
                  height: 50,
                ),
                !loading
                    ? openavatar
                        ? Center(
                          child: Avatar(
                              boxShape: BoxShape.rectangle,
                            ),
                        )
                        : Container()
                    : Container(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      ),
                StreamBuilder(
                    stream: Future.value(AvatarState.imagepicked).asStream(),
                    builder: (con, snap) {
                      if (AvatarState.imagepicked) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 171, 83, 149),
                            textStyle:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            backgroundColor: Color.fromARGB(255, 229, 33, 243),
                            splashFactory: InkRipple.splashFactory,
                            foregroundColor: Color.fromARGB(255, 0, 0, 0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text('Submit'),
                          onPressed: () {
                            submit();
                          },
                        );
                      }
                      return Container();
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Your Images: ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Center(
                  child: FutureBuilder(
                    future: getlinks(),
                    builder: ((context, snapshot)  {
              
                      while(!snapshot.hasData){
                        return Center(child: Container(height: 30, width: 30, child: CircularProgressIndicator(),));
                      } 
                    
                      return ListImages(imageslist:   snapshot.data!, height: 240, width: 150,);
                    }),
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}


