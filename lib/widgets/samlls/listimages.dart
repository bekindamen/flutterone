import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListImages extends StatefulWidget {
  List<String> imageslist;
  double height, width;
  ListImages({super.key, required this.imageslist, required this.height, required this.width});

  @override
  State<ListImages> createState() => _ListImagesState();
}

class _ListImagesState extends State<ListImages> {

  final _controller = ScrollController();

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }


  List<Widget> getImageWidgets(List<String> imageUrls) {
  return imageUrls.map((url) => Card(
    color: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  
                    height: widget.height,
                    width: widget.width,
                    child: FittedBox( fit: BoxFit.fill, child: Image.network(url))))))
        .toList();
  }

List<Widget> list = [];
@override
void initState(){
  super.initState();

  
  
}

  @override
  Widget build(BuildContext context) {
    return Wrap(
      verticalDirection: VerticalDirection.up,
      spacing: 16,
      runSpacing: 32,
      children: getImageWidgets(widget.imageslist),
    );
  }
}
