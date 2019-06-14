import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import '../models/MainScreenModel.dart';
import 'BlockPage.dart';
import 'webviewPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';


class FavorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FavorPageState();
}

class FavorPageState extends State<FavorPage>{
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    print(model.likedArray);
    createList();
  }

  void createList() async{
    var title = await model.getFavoriteTitle(model.likedArray);
    favorLableList = createFavorList(title);
    print(title);
    setState(() {});
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
  FavorLable(this.lableText,this.index, this.url);

  String lableText;
  int index;
  String url;

  @override
  State<StatefulWidget> createState() => FavorLableState(lableText,index,this, url);
}

class FavorLableState extends State<FavorLable>{
  FavorLableState(this.lableText,this.index,this.copyThis, this.url);

  String lableText;
  int index;
  var copyThis;
  String url;
  bool isFavorite = true;

  // WebViewController
  Completer<WebViewController> _controller;

  void initState() {
    _controller = Completer<WebViewController>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      key: Key(lableText),
      child: ListTile(
        title: Text(lableText),
        subtitle: Text(url),
        onTap: () {
          print("url to show $url");
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new Scaffold(
              appBar: AppBar(
                title: Text(lableText),
                leading: NavigationControls(_controller.future,url,model),
                actions: <Widget>[
                  Menu(_controller.future, url)
                ],
              ),
              floatingActionButton: FavoriteButton(isFavorite, Colors.blue),
              body: new WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  if(! _controller.isCompleted) {
                    _controller.complete(webViewController);
                  }
                },
              ),
            );
          }));
        },
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.center,
        child: Icon(Icons.delete, color: Colors.white,),
//        child: Row(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
////            Text("滑动以删除",style: TextStyle(color: Colors.white,fontSize: 20),),
////            Container(width: window.physicalSize.width.toDouble() * 0.3 / window.devicePixelRatio.toDouble(),),
//            Icon(Icons.delete, color: Colors.white,)
//          ],
//        ),
        color: Colors.red,
      ),
      onDismissed: (direction) {
        model.likedArray.remove(url);
        model.saveArrays();

        favorLableList.remove(lableText);

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
    result.add(FavorLable( targetList[i],i, model.likedArray[i]));
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