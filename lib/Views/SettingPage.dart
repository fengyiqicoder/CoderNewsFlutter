import 'package:flutter/material.dart';
import 'dart:ui';
import 'SettingPages/SettingColorPage.dart';

class SettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      backgroundColor: Color.fromRGBO(241, 241, 241, 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[

            Container(
              width: window.physicalSize.width.toDouble() / window.devicePixelRatio.toDouble(),
//                padding: EdgeInsets.all(10),
              height: 60,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(14, 14, 14, 0.15))),
                color: Colors.white,
              ),
              child: FlatButton(
                color: Colors.white,
                child: settingTile(
                    Icon(Icons.color_lens,color: Colors.grey,),
                    "主题颜色",
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return SettingColorPage();
                  }));
                },
              ),
            ), //主题颜色
          ],
        ),
      ),
    );
  }
}

Stack settingTile(Icon firstIcon, String funcName){
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Positioned(
        child: firstIcon,
        left: 10,
      ),
      Positioned(
        child: Text(
          funcName,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20
          ),
        ),
        left: 50,
      ),
      Positioned(
        child: Icon(Icons.chevron_right,color:Colors.grey,),
        right: 0.1,
      ),
    ],
  );
}

