import 'package:flutter/material.dart';
import 'package:plswork/screens/cooking.dart';
import 'package:plswork/screens/functions/doubts_ai.dart';
import 'package:plswork/screens/searchh.dart';
import 'package:plswork/screens/widget/category.dart';
import 'package:plswork/screens/widget/header.dart';
import 'package:plswork/screens/widget/search.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
            child: Stack(children: [
          Transform(
            transform: Matrix4.identity()..rotateZ(20),
            origin: const Offset(150, 50),
            child: Image.asset(
              'assets/bg_liquid.png',
              width: 200,
            ),
          ),
          Positioned(
            right: 0,
            top: 200,
            child: Transform(
                transform: Matrix4.identity()..rotateZ(20),
                origin: const Offset(180, 100),
                child: Image.asset(
                  'assets/bg_liquid.png',
                  width: 200,
                )),
          ),
          Column(children: [
            const Header(),
            const Search(),
            const Category(),
            const Searchh(),
            const DoubtsAi(),
          ])
        ])));
  }
}
