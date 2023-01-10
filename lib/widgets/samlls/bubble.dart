// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class Bubble extends StatelessWidget {
  const Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlowContainer(
          blurRadius: 4,
          spreadRadius: 3,
          shape: BoxShape.circle,
          animationDuration: Duration(milliseconds: 500),
          animationCurve: Curves.easeIn,
          glowColor: Colors.pinkAccent,
          child: CircleAvatar(
            radius: 10,
            backgroundImage: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/face1.jpg?alt=media&token=5b074786-44f7-495d-b2a8-5d62e15f50f8')
                .image,
          ),
        ),
        GlowContainer(
          blurRadius: 4,
          spreadRadius: 4,
          shape: BoxShape.circle,
          animationDuration: Duration(milliseconds: 500),
          animationCurve: Curves.easeIn,
          glowColor: Colors.pinkAccent,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/face2.jpg?alt=media&token=9aa48d54-8db5-48be-bc32-b350b8a90669')
                .image,
          ),
        ),
        GlowContainer(
            blurRadius: 4,
            spreadRadius: 4,
            shape: BoxShape.circle,
            animationDuration: Duration(milliseconds: 500),
            animationCurve: Curves.easeIn,
            glowColor: Colors.pinkAccent,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/fae3.jpg?alt=media&token=8e860b4f-29b8-4ea7-8767-741ac7546377')
                  .image,
            )),
        GlowContainer(
          blurRadius: 4,
          spreadRadius: 2,
          shape: BoxShape.circle,
          animationDuration: Duration(milliseconds: 500),
          animationCurve: Curves.easeIn,
          glowColor: Colors.pinkAccent,
          child: CircleAvatar(
            radius: 10,
            backgroundImage: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/light-house-219ea.appspot.com/o/dp%2FUYeUZ1K3sGMxQVetfaMk3CrWIoi1.jpg?alt=media&token=fa82f8b9-d0ed-418c-a2fa-a1bb0ca3813d')
                .image,
          ),
        ),
      ],
    );
  }
}
