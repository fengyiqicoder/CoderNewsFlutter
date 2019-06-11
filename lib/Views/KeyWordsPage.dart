import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/KeyWordsModel.dart';
import 'LeftDrawer.dart';
import '../models/Constants.dart';
import '../models/MainScreenModel.dart';

List<String> choosedList = [];
MainModel model ;

class KeyWordsPage extends StatefulWidget {
  KeyWordsPage(this.prePage,list,theModel){
    choosedList = list;
    model = theModel;
  }
  var prePage;

  @override
  State<StatefulWidget> createState() => KeyWordsPageState(prePage);
}

class KeyWordsPageState extends State<KeyWordsPage> {
  KeyWordsPageState(this.prePage);

//  bool pageDoneState = false;
  BuildContext copyContext;
  var prePage;

  checkAlertDialog(){
    return AlertDialog(
      title: Text('保存', style: TextStyle(color: Colors.blue),),
      content: Text('确定保存?'),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '取消',
            style: TextStyle(color: Colors.red,),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            '确认',
            style: TextStyle(color: Colors.blue,),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            print(chooseResult);
            choosedList.clear();
            int n = chooseResult.length;
            for(int i = 0; i < n; i++){
              choosedList.add(chooseResult[i]);
            }
            chooseResult.clear();
            Navigator.of(copyContext).pop();
            drawerList = choosedList;
            prePage.setState((){});
          },
        ),
      ],
    );
  }

  cancleAlertDialog(){
    return AlertDialog(
      title: Text('取消', style: TextStyle(color: Colors.red),),
      content: Text('取消保存?'),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '取消',
            style: TextStyle(color: Colors.red,),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            '确认',
            style: TextStyle(color: Colors.blue,),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            //储存到Model
            model.updateCategoryArray(choosedList);
            print(choosedList);
            chooseResult.clear();
            Navigator.of(copyContext).pop();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int n = choosedList.length;
    for(int i = 0; i < n; i++){
      chooseResult.add(choosedList[i]);
    }
    print(chooseResult);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    copyContext = this.context;

    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.red,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => cancleAlertDialog(),
            );
          },
        ),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.done),
          color: Colors.blue,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => checkAlertDialog(),
            );
          },
        )],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleText("添加标签",40,Colors.black),
            TitleText("添加你感兴趣的标签", 15, Colors.grey),
            Spacing(5),
            CutLine(),
            TitleText("语言种类", 25, Colors.red),
            Wrap(
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.start,
              children:createKeyLableList(Constants.lankeywords, choosedList),
            ),
            Spacing(5),
            CutLine(),
            TitleText("科技相关", 25, Colors.blue),
            Wrap(
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.start,
              children:createKeyLableList(Constants.techKeywords, choosedList),
            ),
            Spacing(5),
            CutLine(),
          ],
        ),
      ),
    );
  }
}

class CutLine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 1,
      width: window.physicalSize.width.toDouble() / window.devicePixelRatio,
      decoration: BoxDecoration(
        color: Color.fromRGBO(14, 14, 14, 0.1),
      ),
    );
  }
}

class Spacing extends StatelessWidget{
  Spacing(this.size);
  double size;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: size,
    );
  }
}

class TitleText extends StatelessWidget{
  TitleText(this.titleText,this.fontSize,this.colors);

  String titleText;
  double fontSize;
  Color colors;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text(
        titleText,
        style: TextStyle(
          fontSize: fontSize,
          color: colors,
        ),
        textAlign: TextAlign.justify,
      ),
      padding: EdgeInsets.only(left: 10),
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
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: (){
        this.setState((){
          isChoosed = !isChoosed;
        });

        if(isChoosed == true) chooseResult.add(this.keyWord);
        else chooseResult.remove(this.keyWord);
      },
    );
  }
}


