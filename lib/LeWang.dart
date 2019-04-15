import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

const BlockTitleTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
); // TextStyle

const BlockShadow = BoxShadow(
    color:Colors.black54,
    offset: Offset(4.0,4.0),
    blurRadius: 8.0
);

class DefaultTheme {
  static const buttomColor = Colors.pinkAccent;
}

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => new _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  @override
  Widget build(BuildContext context) {
    print("BuildingState");
    // TODO: implement build
    return new Scaffold(
      body: new StaggeredGridView.count(
          crossAxisCount: 2,
          staggeredTiles: counter?_staggeredTitles:_staggeredTitles1, //the style of the blocks
          children: counter?titles:changedTitles, // the information of the blocks
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(vertical: 78,horizontal: 8)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: onTapFloatButton,
        child: Icon(Icons.refresh),
        backgroundColor: DefaultTheme.buttomColor,
      ),
    );
  }

  void onTapFloatButton () {
    this.setState((){
      counter = !counter;
    });
  }
}

class _Blocks extends StatelessWidget {
  _Blocks(this.id, this.newsTitle, this.bgPic);

  var id;
  var newsTitle;
  var bgPic;

  @override
  Widget build(BuildContext context) {
    //使用FadeInImage
    //方法:因为FadeInImage是Widget而不是decoration所以要用Stack布局
    //先判断图片Url是否为Nil如果为nil的话返回decoration如果不为Nil的话返回FadeInImage
    //PS:把id改成URL 并且对url进行判断
    return new GestureDetector(
      child: Container(
        decoration: PicBoxDecoration(bgPic),
        child: new Container(
          decoration: TextBoxDecoration(bgPic),
          child: new Container(
            child: Stack(
              children: <Widget>[
                Text(
                  newsTitle,
                  style: BlockTitleTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                Positioned(
                  child: Row(
                    children: BlockKeyWords("keyWord0", "keyWord1"),
                  ),
                  bottom: 0.2,
                  right: 0.2,
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) {
              return new BlocksTapRoute(id);
            }));
      },
    );
  }
}

List<Widget> BlockKeyWords (keyWord0,keyWord1){
  return <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Color.fromRGBO(96, 98, 92, 0.6),
      ),
      height: 21,
      child:Center(child: Text(keyWord0.toString(),
          style: TextStyle(
            color: Colors.white70,
          )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
    ),
    Container(
      width: 4,
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Color.fromRGBO(96, 98, 92, 0.6),
      ),
      height: 21,
      child:Center(child: Text(keyWord1.toString(),
          style: TextStyle(
            color: Colors.white70,
          )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
    )
  ];
}

BoxDecoration PicBoxDecoration(bgPic){
  if(bgPic == null){
    return new BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BlockShadow],
      color: Colors.pinkAccent, //if the pic is null use the colors
    );
  }
  else{
    return new BoxDecoration(
      image: DecorationImage(
        image: AssetImage(bgPic), //it's an AssetImage from local,can changed with NetworkImage
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(20),
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
      borderRadius: BorderRadius.circular(20),
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

bool counter = true;

List<Widget> titles = <Widget>[
  _Blocks(0,titlestext[3],null),
  _Blocks(1,titlestext[0],"images/bgpic1.png"),
  _Blocks(2,titlestext[1],"images/bgpic2.jpg"),
  _Blocks(3,titlestext[2],"images/bgpic3.jpeg"),
];

List<Widget> changedTitles = <Widget>[
  _Blocks(0,titlestext[1],"images/bgpic0.jpg"),
  _Blocks(1,titlestext[2],"images/bgpic1.png"),
  _Blocks(2,titlestext[0],"images/bgpic2.jpg"),
  _Blocks(3,titlestext[3],"images/bgpic3.jpeg"),
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