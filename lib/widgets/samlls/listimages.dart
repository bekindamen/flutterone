import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListImages extends StatefulWidget {
  Future<List<String>> imageslist;
  ListImages({super.key, required this.imageslist});

  @override
  State<ListImages> createState() => _ListImagesState();
}

class _ListImagesState extends State<ListImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: widget.imageslist,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> list = [];
          widget.imageslist.then(
            (value) {
              list = value;
            },
          );
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                      height: 120,
                      width: 75,
                      child: Image(image: Image.network(list[index]).image)),
                );
              });
        } else {
          return Center(
              child: Container(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ));
        }
      },
    ));
  }
}
