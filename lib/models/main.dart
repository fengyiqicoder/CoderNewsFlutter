import 'package:flutter/material.dart';
//import 'LeWang.dart';
import 'package:helloflutter/Views/BlockPage.dart';
//import '../Views/newDesignFile.dart';
import 'Network.dart';

void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
//    home: new MyScaffold(),
    home: BlockPage(),
  ));
}

