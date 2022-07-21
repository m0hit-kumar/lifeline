import 'package:flutter/material.dart';
import 'package:lifeline/MainPage.dart';
import 'package:lifeline/pages/MyMainPage.dart';
// import 'dart:html';

void main() => runApp(const HomePage());

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainPage());
  }
}
