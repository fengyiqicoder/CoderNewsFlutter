import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Network.dart';
import 'MainScreenModel.dart';
import 'Constants.dart';
import 'package:transparent_image/transparent_image.dart';

const BlockTitleTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
); // TextStyle

const BlockShadow = BoxShadow(
    color:Colors.black38,
    offset: Offset(2.0,2.0),
    blurRadius: 4.0
);

//数据控制
var model = MainModel();

class BlockPage extends StatefulWidget {

  const BlockPage({Key key});

  @override
  BlockPageState createState() {
//    print("CreateState");
    return new BlockPageState();
  }
}

class BlockPageState extends State<BlockPage> {//从Model获取数据进行展示
  List<StaggeredTile> currentTile = [] ;
  List<Widget> currentWidgets = [] ;

  @override
  void initState() {
    print("initState");
    super.initState();
    //在这里获取网络数据
    getDatasForView();
  }


  @override
  Widget build(BuildContext context) {
    print("Building Page");
    if (currentTile == []){
      return Scaffold();//return emtry views
    }
    return new Scaffold(
      body: new StaggeredGridView.count(
        crossAxisCount: 2,
        staggeredTiles: currentTile, //the style of the blocks
        children: currentWidgets, // the information of the blocks
        controller: ScrollController(initialScrollOffset: 0.0,keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        mainAxisSpacing: ConstantsForTile.axiaGap,
        crossAxisSpacing: ConstantsForTile.axiaGap,
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 8)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onTapFloatButton,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void onTapFloatButton () {
    //在这里获取数据
    print("tappingButton");
    getDatasForView();
  }

  void getDatasForView() async {
    var tileList = model.getATileList();
    var widgetList = model.getWidgets(tileList);
    currentWidgets = await widgetList;//更新数据
    currentTile = tileList;
    print("DataLanding");
    this.setState((){
      //刷新页面
      print("updateViews");
    });
  }

}

class Blocks extends StatefulWidget {//输入一个JSON数据,自动展示这个tile
  Blocks(this.url, this.newsTitle, this.bgPic);

  Blocks.withJson(Key key,Map jsonData,int textMaxLine):super (key:key){
    url = jsonData["infoId__url"];
    newsTitle = jsonData["infoId__title"];
    bgPic = jsonData["infoId__imageURL"];
    var tagName = jsonData["infoId__category"];
    tagsArray.add(tagName);
    this.textMaxLine = textMaxLine;
  }

  var url;
  var newsTitle;
  var bgPic;
  var textMaxLine;
  List<String> tagsArray = [];

  @override
  BlocksState createState(){
//    print("CreateState");
//    print(newsTitle);
    return BlocksState(url,newsTitle,bgPic,tagsArray,textMaxLine);
  }
}

class BlocksState extends State<Blocks> {

  BlocksState(this.url,this.newsTitle,this.bgPic,this.tagsArray,this.textMaxLine);

  var url;
  var newsTitle;
  var bgPic;
  var textMaxLine;
  List<String> tagsArray = [];

  @override
  Widget build(BuildContext context) {
//    print("BlockStateBuilding");
    // TODO: implement build
//    print(newsTitle);
    return new GestureDetector(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BlocksBackgroundPic(bgPic),
          bgPic == "nil"
              ? TitleWithGlass(newsTitle,textMaxLine)
              : TitleWithoutGlass(newsTitle,textMaxLine),
          Positioned(
            child: Row(
              children: BlockKeyWords(tagsArray),
            ),
            bottom: 10.0,
            right: 10.0,
          ),
        ],
      ),
    );
  }

}

Widget BlocksBackgroundPic(url) {
  if (url == "nil") {
        //获取一些颜色
    var color = model.getATileColor();
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BlockShadow],
        color: color,
      ),
    );
  } else {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BlockShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
//        child: Image.network(
//          url,
//          fit: BoxFit.cover,
//        ),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget TitleWithGlass(newsTitle,maxLine) {//这个方法和下一个方法合成一个 等待重构
  return new Container(
    child: Text(
      newsTitle,
      style: BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}

Widget TitleWithoutGlass(newsTitle,maxLine) {
  return new Container(
    child: Text(
      newsTitle,
      style: BlockTitleTextStyle,
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

List<Widget> BlockKeyWords (List<String> keywordArray){
  List<Widget> keyWordList = [];
  for (var tagName in keywordArray){
    var widget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Color.fromRGBO(96, 98, 92, 0.6),
      ),
      height: 21,
      child:Center(child: Text(tagName,
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

class BlocksTapRoute extends StatefulWidget{
  BlocksTapRoute(this.id);

  var id;
  @override
  State<StatefulWidget> createState() => new _BlocksTapRouteState(id);

}

class _BlocksTapRouteState extends State<BlocksTapRoute>{
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