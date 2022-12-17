// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatefulWidget {
  List<String> list;
  ImageBuilder({super.key, required this.list});

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  List<Widget> mylist = [];
  @override
  void initState() {
    super.initState();
    int temp = 0;

    for (int i = 0; i < widget.list.length; i += 2) {
      if ((widget.list[i + 1] != null)) {
        Widget w1 = PhysicalModel(
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 8,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: 160,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.network(widget.list[i]).image)),
            ),
          ),
        );

        Widget w2 = PhysicalModel(
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 8,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: 160,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.network(widget.list[i + 1]).image)),
            ),
          ),
        );
        mylist.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            w1,
            SizedBox(
              width: 30,
            ),
            w2
          ],
        ));
        mylist.add(SizedBox(
          height: 10,
        ));
      } else {
        mylist.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhysicalModel(
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 8,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 160,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(widget.list[i]).image)),
                ),
              ),
            )
          ],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      shadowColor: Color.fromARGB(155, 0, 0, 0),
      elevation: 4,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Colors.red,
          child: SingleChildScrollView(
            child: Column(
              children: mylist,
            ),
          ),
        ),
      ),
    );
  }
}
