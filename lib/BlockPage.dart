import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Network.dart';
import 'MainScreenModel.dart';
import 'Constants.dart';

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
  @override
  BlockPageState createState() => new BlockPageState();
}

class BlockPageState extends State<BlockPage> {//从Model获取数据进行展示
  List<StaggeredTile> currentTile = _staggeredTitles ;
  List<Widget> currentWidgets = titles ;
  @override
  Widget build(BuildContext context) {
    print("Building Page");
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
//    this.setState((){
    getDatasForView();
//    });
  }

  void getDatasForView() async {
    var tileList = model.getATileList();
    var widgetList = model.getWidgets(tileList.length);
    currentWidgets = await widgetList;//更新数据
    currentTile = tileList;
    print("DataLanding");
    this.setState((){
      //刷新页面
      print("updateViews");
    });
  }
}

class Blocks extends StatelessWidget {//输入一个JSON数据,自动展示这个tile
  Blocks(this.url, this.newsTitle, this.bgPic);

  Blocks.withJson(Map jsonData){
    url = jsonData["infoId__url"];
    newsTitle = jsonData["infoId__title"];
    var picString = jsonData["infoId__imageURL"];
//    print(picString == "nil");
    bgPic = picString == "nil" ? null : picString ;
  }

  var url;
  var newsTitle;
  var bgPic;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      child: Container(
        decoration: PicBoxDecoration(bgPic),
        child: new Container(
          decoration: TextBoxDecoration(bgPic),
          child: new Container(
            child: Text(
              newsTitle,
              style: BlockTitleTextStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: ConstantsForTile.textMaxLine,
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context,//进入下一个页面
        new MaterialPageRoute(builder: (context) {
          return new BlocksTapRoute(url);
        }));
      },
    );
  }
}

BoxDecoration PicBoxDecoration(bgPic){
  if(bgPic == null){
    //获取一些颜色
    var color = model.getATileColor();
    return new BoxDecoration(
      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
      boxShadow: [BlockShadow],
      color: color, //if the pic is null use the colors
    );
  }
  else{
    return new BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(bgPic), //it's an AssetImage from local,can changed with NetworkImage
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
      boxShadow: [BlockShadow],
    );
  }
}

BoxDecoration TextBoxDecoration(bgPic){
  if(bgPic == null){
    return BoxDecoration(); // non pic without color
  }
  else{
    return new BoxDecoration(
      color: Color.fromRGBO(14, 14, 14, 0.3), //this is the color between the image and text
      borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
    );
  }
}

List<StaggeredTile> _staggeredTitles = <StaggeredTile>[
  StaggeredTile.count(2, 1),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
];

List<StaggeredTile> _staggeredTitles1 = <StaggeredTile>[
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 1),
];



List<Widget> titles = <Widget>[
  Blocks(0,titlestext[3],null),
  Blocks(1,titlestext[0],null),
  Blocks(2,titlestext[1],null),
  Blocks(3,titlestext[2],null),
];

List<Widget> changedtitles = <Widget>[
  Blocks(0,titlestext[1],"images/bgpic0.jpg"),
  Blocks(1,titlestext[2],"images/bgpic1.png"),
  Blocks(2,titlestext[0],"images/bgpic2.jpg"),
  Blocks(3,titlestext[3],"images/bgpic3.jpeg"),
];

List<String> titlestext = <String>[
  "this is the fucking title",
  "lover~ fucker~",
  "do you fell cold and lost in desperation?",
  "you build up hope and failures all you know,remember all the sadness and frustration,and let it go,let it go"
];

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