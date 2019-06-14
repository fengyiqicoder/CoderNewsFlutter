import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

class FavorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FavorPageState();
}

class FavorPageState extends State<FavorPage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favorLableList = createFavorList(testFavorList);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("我赞过的"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: favorLableList,
        ),
      ),
    );
  }
}

class FavorLable extends StatefulWidget{
  FavorLable(this.lableText,this.index);

  String lableText;
  int index;

  @override
  State<StatefulWidget> createState() => FavorLableState(lableText,index,this);
}

class FavorLableState extends State<FavorLable>{
  FavorLableState(this.lableText,this.index,this.copyThis);

  String lableText;
  int index;
  var copyThis;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      key: Key(lableText),
      child: ListTile(
        title: Text(lableText),
        subtitle: Text("keywords"),
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("滑动以删除",style: TextStyle(color: Colors.white,fontSize: 20),),
            Container(width: window.physicalSize.width.toDouble() * 0.3 / window.devicePixelRatio.toDouble(),),
            Icon(Icons.delete, color: Colors.white,)
          ],
        ),
        color: Colors.red,
      ),
      onDismissed: (direction) {
        favorLableList.remove(copyThis);
        testFavorList.remove(lableText);

        print(testFavorList);

        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("成功删除"))
        );
      },
    );
  }
}

Container slidBackGround = new Container(
  child: Center(child: Text("Slid to Delete",style: TextStyle(color: Colors.white),),),
  color: Colors.red,
);

List<Widget> createFavorList(List<String> targetList){
  int n = targetList.length;
  List<Widget> result = [];

  for(int i = 0; i < n; i ++){
    result.add(FavorLable( targetList[i],i));
  }

  return result;
}

List<Widget> favorLableList = [];

List<String> testFavorList = [
  "Non terrrae plus ultra",
  "Leave out all the rest",
  "Don't put the blame on me, don't put the blame on me",
  "Kill the DJ"
];