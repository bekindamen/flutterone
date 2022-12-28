import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterone/widgets/samlls/listimages.dart';
import 'package:http/http.dart' as http;

class Opened extends StatefulWidget {
  String url;
  String id;
  Opened({super.key, required this.url, required this.id});

  @override
  State<Opened> createState() => _OpenedState();
}

class _OpenedState extends State<Opened> {
   
   int age =0;
   String email ='';
 String  dplink = '';
bool urlgot = false;
final _controller = ScrollController();

  getdetails()async{
    final dpUrl = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await dpUrl.get();

    snapshot.data()!.forEach((key, value) {
      if (key == 'dpUrl') {
        setState(() {
          dplink = value.toString();

        });
      
      }
    });
    
    var res = await http.get(Uri.parse('http://54.234.140.51:8000/api/personaldata/' + widget.id ));
    Map<String, dynamic> map = jsonDecode(res.body.toString());
      age = int.parse(map['data']['age']) ;
        email = map['data']['email'];
 setState(() {
      urlgot = true;
    });
  }
 Future<List<String>> getimages( ) async{
  List<String> imageslist = [];

    var  res =await http.get(Uri.parse('http://54.234.140.51:8000/api/personaldata/' + widget.id));
    Map<String, dynamic> map = jsonDecode(res.body.toString());
   List<dynamic> imageslisttemp = map['data']['images'];
    imageslisttemp.forEach((element) { imageslist.add(element['link']);});
    return imageslist;
  }


  @override
  void initState(){
    super.initState();
    getdetails();
    
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onDoubleTap: ( ) {
                Navigator.pop(context);
              },
             
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.grey, automaticallyImplyLeading: false, centerTitle: true, 
        title: Text("User's Details",),),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text('(Double tap to exit.)' ,style: TextStyle(color: Colors.red),),
                Container(
                  height: 620,
                  width: 450,
                  child: Hero(
                    tag: widget.url,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image(
                          image: Image.network(
                                  widget.url)
                              .image),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                        
                            child: Container(height: 120, width: 75, color: Colors.grey, child:urlgot ? Image(
                                image: Image.network(
                                        dplink)
                                    .image): Center(child: Container(height: 30, width: 30, child: CircularProgressIndicator())) ,),
                          ),
                       SizedBox(width: 30,),
                            Column(
                              children: [
                                Row(children: [
                                  Text('Email: '), urlgot ? Text(email, ): Container(height: 10, width: 10, child: CircularProgressIndicator(),)
                                  ],),
                                  Row(children: [
                                  Text('Age: '), urlgot ? Text(age.toString()): Container(height: 10, width: 10, child: CircularProgressIndicator(),)
                                  ],),
                              ],
                            )
                      ],
                    ), 
                    SizedBox(height: 30,),
             FutureBuilder(future: getimages(), builder: ((context, snapshot) {
               while(!snapshot.hasData){
                return Container(height: 20, width: 20 , child: CircularProgressIndicator(),);
               }

               return ListImages(imageslist: snapshot.data!, height: 240, width: 150,);
             }) 
             )
              ],
            ),
          ),
        ),
      ),
    ) ;
  }
}
