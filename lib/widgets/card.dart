// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TinderLikeCard extends StatefulWidget {
  String color;
  TinderLikeCard({required this.color, super.key});

  @override
  State<TinderLikeCard> createState() => _TinderLikeCardState();
}

class _TinderLikeCardState extends State<TinderLikeCard>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  var _doubleTapDetails;
  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
  }

  void _handleDoubleTap() {
    Matrix4 _endMatrix;
    Offset _position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      _endMatrix = Matrix4.identity();
    } else {
      _endMatrix = Matrix4.identity()
        ..translate(-_position.dx * 2, -_position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: _endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 6,
                    color: Color.fromARGB(95, 0, 0, 0),
                    spreadRadius: 4)
              ]),
              child: Image(
                image: Image.network(widget.color).image,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.85,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
