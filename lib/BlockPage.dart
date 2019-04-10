import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

const BlockTitleTextStyle = TextStyle(
  fontSize: 30,
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
    // TODO: implement build
    return new Scaffold(
      body: new StaggeredGridView.count(
        crossAxisCount: 2,
        staggeredTiles: counter?_staggeredTitles:_staggeredTitles1, //the style of the blocks
        children: counter?titles:changedtitles, // the information of the blocks
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 8)
      ),
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
              maxLines: 5,
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

List<Widget> changedtitles = <Widget>[
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