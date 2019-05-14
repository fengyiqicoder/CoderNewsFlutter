import 'package:flutter/material.dart';

class KeyWordsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KeyWordsPageState();
}

class KeyWordsPageState extends State<KeyWordsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose the key that you like",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.red,
          onPressed: () {},
        ),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.done),
          color: Colors.blue,
          onPressed: () {},
        ),],
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.all(4.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                createKeyLableList(testKeyWords1, testChoosedList),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KeyLable extends StatefulWidget{
  KeyLable(this.keyWord,this.isChoosed);

  String keyWord = "Nil";

  bool isChoosed = false;

  @override
  State<StatefulWidget> createState() => KeyLableState(keyWord,isChoosed);
}

class KeyLableState extends State<KeyLable>{
  KeyLableState(this.keyWord,this.isChoosed);

  String keyWord;

  bool isChoosed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(keyWord),
        ],
      ),
      color: isChoosed ? Colors.pinkAccent : Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: (){
        this.setState((){
          isChoosed = !isChoosed;
        });
      },
    );
  }
}

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

List<String> testKeyWords1 = [
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

List<String> testKeyWords2 = [
  "iPhone",
  "Sumsung",
  "Non Terrae Plus Ultra",
  "Chicken you're beautiful",
  "How to play basketball",
  "Ur moves like cxk",
  "Pass ball cxk",
  "Jackpot"
];

List<String> testChoosedList = [
  "C++",
  "Flutter",
  "Dart",
  "C#",
  "UE4",
  "Unity",
  "Go",
];