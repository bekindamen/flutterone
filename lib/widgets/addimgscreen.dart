// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
   import 'dart:io';
 
 import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

// Stream<bool> getboolstream(Future<bool> mybool )async*{
//   while (true){
//     yield await mybool;
//     Future.delayed(Duration(microseconds: 500));
//   }
  
// }


  bool loading = false;
  Future<void> submit() async {
    
    setState(() {
      loading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    File imagePicked = File((AvatarState.pickedImage)!.path);

var request = await http.MultipartRequest('POST', Uri.parse('http://54.234.140.51:5000/images'));
request.files.add(await http.MultipartFile.fromPath('image', imagePicked.path));

var response = await request.send();

if (response.statusCode == 200) {
  String id ='';
  
  await  response.stream.bytesToString().then((value) {
      var json = jsonDecode(value.toString());
      setState(() {
        id = json['image_id'];
      });
    });
 

   
 var res = await http.get(Uri.parse('https://2h871ys0o2.execute-api.ap-south-1.amazonaws.com/test3/getrekog?objectid=' + id));

 if(res.body.toString().contains('Swimwear') || res.body.toString().contains('Revealing') || res.body.toString().contains('Explicit') || res.body.toString().contains('Nudity') || res.body.toString().contains('Sexual')){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.transparent,content: ClipRRect(borderRadius: BorderRadius.circular(15), child: Center(child: Container(height: 60, width: MediaQuery.of(context).size.width * 0.8, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Colors.pink, Colors.pink]), ), child: Text('Do not upload inappropriate photo', style: TextStyle(color: Colors.black, fontSize: 10),),)))));
   
 }else{
 var uuid = genuuid();
    
    String imgurl = '';
    try {
      final ref = FirebaseStorage.instance.ref().child(uuid + '.jpg');
      await ref.putFile(imagePicked);
            var push = await http.get(Uri.parse('http://54.234.140.51:8082'));

      imgurl = await ref.getDownloadURL();
      print(imgurl);
       Map<String, Map<String, Map<String, String>>> bodydata =   <String, Map<String, Map<String, String>>>{
        
         push.body.toString(): {
          "images": { "_id": uid,
                       "link": imgurl}
        }
       
      };

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
      String age = map['data']['age'].toString();
      print(age);
      var res = await http.put(
        Uri.parse('http://54.234.140.51:8000/api/ages/' + age),
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
  setState(() {
        AvatarState.imagepicked = false;
        AvatarState.pickedImage = null;
        loading = false;
      });
}
else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        
          content: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Center(
                  child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.pink, Colors.pink]),
                ),
                child: Text(
                  'Could not uplaod photo',
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              )))));

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
                    : Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                    ),
                StreamBuilder(
                    stream: Future.value(AvatarState.imagepicked).asStream(),
                    builder: (con, snap) {
                      
                            if (AvatarState.imagepicked) {
                              return Center(
                                  child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 171, 83, 149),
                                  textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  backgroundColor:
                                      Color.fromARGB(255, 229, 33, 243),
                                  splashFactory: InkRipple.splashFactory,
                                  foregroundColor: Color.fromARGB(255, 0, 0, 0),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: Text('Submit'),
                                onPressed: () {
                                  submit();
                          },
                        ));
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


