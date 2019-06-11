import 'package:flutter/material.dart';
import '../Views/KeyWordsPage.dart';

List<String> chooseResult = [];



List<Widget> createKeyLableList(List<String> keyList, List<String> chooseList){
  int n = keyList.length;

  List<bool> islableChoosed = isLableChoosed(keyList, chooseList);
  List<Widget> result = [];

  for(int i = 0; i < n; i++){
    result.add(KeyLable(keyList[i], islableChoosed[i]));
  }

  return result;
}

List<bool> isLableChoosed(List<String> keyList, List<String> chooseList){
  int n = keyList.length;
  int m = chooseList.length;

  List<bool> result = [];

  for(int i = 0; i < n; i++){
    result.add(false);
  }

  for(int i = 0; i < n; i++){
    for(int j = 0; j < m; j++){
      if(keyList[i] == chooseList[j]){
        result[i] = true;
      }
    }
  }

  return result;
}



List<String> lanKeyWords = [
  "Java",
  "Python",
  "C++",
  "Flutter",
  "Dart",
  "C#",
  "UE4",
  "Unity",
  "Go",
  "SQL",
];

List<String> tecKeyWords = [
  "iPhone",
  "Sumsung",
  "Non Terrae Plus Ultra",
  "Chicken you're beautiful",
  "How to play basketball",
  "Ur moves like cxk",
  "Pass ball cxk",
  "Jackpot"
];

