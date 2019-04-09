import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const BlockTitleTextStyle = TextStyle(
  fontSize: 30,
  color: Colors.white,
);

const BlockShadow = BoxShadow(
    color:Colors.black54,
    offset: Offset(4.0,4.0),
    blurRadius: 4.0
);

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
        staggeredTiles: _staggeredTitles,
        children: titles,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 8)
      ),
    );
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
        decoration: new BoxDecoration(
          image: DecorationImage(
            image:AssetImage(bgPic),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BlockShadow
          ],//boxShadow
          color: Colors.white ,
        ),
        child: new Container(
          child: Text(newsTitle,
            style: BlockTitleTextStyle,
          ),
          padding: EdgeInsets.all(10),
        ),
      ),
      onTap: onBlocksTap,
    );
  }

  void onBlocksTap(){
    print("This is the $id block");
  }
}

List<StaggeredTile> _staggeredTitles = <StaggeredTile>[
  StaggeredTile.count(2, 1),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
];

List<Widget> titles = <Widget>[
  _Blocks(0,"this is the fucking title","images/bgpic0.jpg"),
  _Blocks(1,"this is the fucking title","images/bgpic1.png"),
  _Blocks(2,"this is the fucking title","images/bgpic2.jpg"),
  _Blocks(3,"this is the fucking title","images/bgpic3.jpeg"),
];
