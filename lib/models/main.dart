import 'package:flutter/material.dart';
import '../Views/LeWang.dart';
//import '../Views/BlockPage.dart';
import 'Network.dart';

void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
//    home: new MyScaffold(),
    home: BlockPage(),
  ));
}

