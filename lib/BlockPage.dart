import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'MainScreenModel.dart';
import 'Constants.dart';
import 'dart:ui';


//数据控制
var model = MainModel();
//屏幕具中
var ScreenSize = window.physicalSize; //real px
var Pixel = window.devicePixelRatio;
var PaddingTopSize = window.padding.top;

class BlockPage extends StatefulWidget {
  const BlockPage({Key key});

  @override
  BlockPageState createState() {
//    print("CreateState");
    return new BlockPageState();
  }
}

class BlockPageState extends State<BlockPage> {
  //从Model获取数据进行展示
  List<StaggeredTile> currentTile = [];

  List<Blocks> currentWidgets = [];

  @override
  void initState() {
    print("initState");
    super.initState();
    //在这里获取网络数据
    getDatasForView();
  }

  @override
  Widget build(BuildContext context) {
    var WidgetHeight = (ScreenSize.width.toDouble() / 2) * 3;
    var PaddingSize = (ScreenSize.height.toDouble() - WidgetHeight + PaddingTopSize.toDouble()) / 2 / Pixel;
    print("Building Page");
    if (currentTile == []) {
      return Scaffold(); //return emtry views
    }
    return new Scaffold(
      body: new StaggeredGridView.count(
          crossAxisCount: 2,
          staggeredTiles: currentTile,
          //the style of the blocks
          children: currentWidgets,
          // the information of the blocks
          controller: ScrollController(
              initialScrollOffset: 0.0, keepScrollOffset: false),
          scrollDirection: Axis.vertical,
          mainAxisSpacing: ConstantsForTile.axiaGap,
          crossAxisSpacing: ConstantsForTile.axiaGap,
          padding: EdgeInsets.symmetric(vertical: PaddingSize, horizontal: 8)),
      floatingActionButton: FloatingActionButton(
        onPressed: onTapFloatButton,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void onTapFloatButton() {
    //在这里获取数据
    currentWidgets.forEach((view){
      view.controller.reverse();
    });
    print("tappingButton");
    getDatasForView();
  }

  void getDatasForView() async {
    var tileList = model.getATileList();
    var widgetList = model.getWidgets(tileList);
    currentWidgets = await widgetList; //更新数据
    currentTile = tileList;
    print("DataLanding");
    this.setState(() {
      //刷新页面
      print("updateViews");
    });
  }
}

class Blocks extends StatefulWidget {
  //输入一个JSON数据,自动展示这个tile
  //Build方法
  Blocks.withJson(Key key, Map jsonData, int textMaxLine,Color color) : super(key: key) {
    url = jsonData["infoId__url"];
    newsTitle = jsonData["infoId__title"];
    bgPic = jsonData["infoId__imageURL"];
    var tagName = jsonData["infoId__category"];
    tagsArray.add(tagName);
    this.textMaxLine = textMaxLine;
    this.color = color;
  }

  var url;
  var newsTitle;
  var bgPic;
  var textMaxLine;
  List<String> tagsArray = [];
  //静态方法找到State
//  static BlocksState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<BlocksState>());

  var context;
  var color;
  //创建state
  AnimationController controller;
  @override
  BlocksState createState() {
//    print("CreateState");
    var newState = BlocksState(url, newsTitle, bgPic, tagsArray, textMaxLine,color);
    controller = new AnimationController(
        duration: const Duration(milliseconds: 550), vsync: newState);
//    print("CreateController");
    newState.controller = controller;
    this.context = newState.context;
    return newState;
  }
}

class BlocksState extends State<Blocks> with SingleTickerProviderStateMixin {
  //Build方法
  BlocksState(
      this.url, this.newsTitle, this.bgPic, this.tagsArray, this.textMaxLine,this.color);

  //数据源
  var url;
  var newsTitle;
  var bgPic;
  var textMaxLine;
  var color;
  List<String> tagsArray = [];

  //Animation
  Animation<double> animation;
  AnimationController controller;

  //lifeCycle

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inintState");
    animation = new Tween(begin: 0.2, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    animation = CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
    //启动动画(正向执行)
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
//    print("BlockStateBuilding");
    // TODO: implement build
//    print(newsTitle);
    return Opacity(
        opacity: animation.value,
        child: GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BlocksBackgroundPic(bgPic,color),
              bgPic == "nil"
                  ? TitleWithGlass(newsTitle, textMaxLine)
                  : TitleWithoutGlass(newsTitle, textMaxLine),
              Positioned(
                child: Row(
                  children: BlockKeyWords(tagsArray),
                ),
                bottom: 10.0,
                right: 10.0,
              ),
            ],
          ),
        ));
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}

Widget BlocksBackgroundPic(url,color) {
  if (url == "nil") {
    //获取一些颜色
//    var color = Colors.pink;
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [ConstantsForTile.BlockShadow],
        color: color,
      ),
    );
  } else {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [ConstantsForTile.BlockShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
//        child: Image.network(
//          url,
//          fit: BoxFit.cover,
//        ),
        child: FadeInImage(
          placeholder: AssetImage("images/Pulse.gif"),
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget TitleWithGlass(newsTitle, maxLine) {
  //这个方法和下一个方法合成一个 等待重构
  return new Container(
    child: Text(
      newsTitle,
      style: ConstantsForTile.BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}

Widget TitleWithoutGlass(newsTitle, maxLine) {
  return new Container(
    child: Text(
      newsTitle,
      style: ConstantsForTile.BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(14, 14, 14, 0.3),
    ),
  );
}

List<Widget> BlockKeyWords(List<String> keywordArray) {
  List<Widget> keyWordList = [];
  for (var tagName in keywordArray) {
    var widget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Color.fromRGBO(96, 98, 92, 0.6),
      ),
      height: 21,
      child: Center(
        child: Text(tagName,
            style: TextStyle(
              color: Colors.white70,
            )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
    keyWordList.add(widget);
  }
  return keyWordList;
}

//BoxDecoration PicBoxDecoration(bgPic){
//  if(bgPic == null){
//    //获取一些颜色
//    var color = model.getATileColor();
//    return new BoxDecoration(
//      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
//      boxShadow: [BlockShadow],
//      color: color, //if the pic is null use the colors
//    );
//  }
//  else{
//    return new BoxDecoration(
//      image: DecorationImage(
//        image: NetworkImage(bgPic),
//        fit: BoxFit.cover,
//      ),
//      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
//      boxShadow: [BlockShadow],
//    );
//  }
//}
//
//BoxDecoration TextBoxDecoration(bgPic){
//  if(bgPic == null){
//    return BoxDecoration(); // non pic without color
//  }
//  else{
//    return new BoxDecoration(
//      color: Color.fromRGBO(14, 14, 14, 0.3), //this is the color between the image and text
//      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
//    );
//  }
//}

class BlocksTapRoute extends StatefulWidget {
  BlocksTapRoute(this.id);

  var id;

  @override
  State<StatefulWidget> createState() => new _BlocksTapRouteState(id);
}

class _BlocksTapRouteState extends State<BlocksTapRoute> {
  _BlocksTapRouteState(this.id);

  var id;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Center(
        child: Text(id.toString()),
      ),
    );
  }
}
