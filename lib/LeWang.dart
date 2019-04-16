import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const BlockTitleTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
  shadows: [BlockShadow],
); // TextStyle

const BlockShadow =
    BoxShadow(color: Colors.black54, offset: Offset(4.0, 4.0), blurRadius: 8.0);

class DefaultTheme {
  static const buttomColor = Colors.pinkAccent;
}

var ScreenSize = window.physicalSize; //real px
var Pixel = window.devicePixelRatio;

//把之前的DecorationBox换成FadeInImage提示图片获取效果
//方法:因为FadeInImage是Widget而不是decoration所以要用Stack布局
//先判断图片Url是否为Nil如果为nil的话返回decoration如果不为Nil的话返回FadeInImage
//PS:把id改成URL 并且对url进行判断
//网站: https://docs.flutter.io/flutter/widgets/FadeInImage-class.html
//https://flutterchina.club/cookbook/images/fading-in-images/

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => new _BlockPageState();
}

class _BlockPageState extends State<BlockPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var WidgetHeight = (ScreenSize.width.toDouble() / 2) * 3;
    var PaddingSize = (ScreenSize.height.toDouble() - WidgetHeight) / 2 / Pixel;

    return new Scaffold(
      body: new StaggeredGridView.count(
          crossAxisCount: 2,
          staggeredTiles: counter ? _staggeredTitles : _staggeredTitles1,
          //the style of the blocks
          children: counter ? titles : changedTitles,
          // the information of the blocks
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(vertical: PaddingSize, horizontal: 8),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: onTapFloatButton,
        child: Icon(Icons.refresh),
        backgroundColor: DefaultTheme.buttomColor,
      ),
    );
  }

  void onTapFloatButton() {
    setState(() {
      counter = !counter;
    });
  }
}

class Blocks extends StatefulWidget {
  Blocks(this.url, this.newsTitle, this.keyWords);

  var url;
  var newsTitle;
  List keyWords;

  @override
  State<StatefulWidget> createState() => BlocksState(url, newsTitle, keyWords);
}

class BlocksState extends State<Blocks> {
  BlocksState(this.url, this.newsTitle, this.keyWords);

  var url;
  var newsTitle;
  List keyWords;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BlocksBackgroundPic(url),
          url == "Nil"
              ? TitleWithGlass(newsTitle)
              : TitleWithoutGlass(newsTitle),
          Positioned(
            child: Row(
              children: BlocksKeyWords(keyWords),
            ),
            bottom: 10.0,
            right: 10.0,
          ),
        ],
      ),
      onTap: onBlocksTap,
    );
  }

  void onBlocksTap(){
    print(url);
  }
}

Widget BlocksBackgroundPic(url) {
  if (url.toString() == "Nil") {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BlockShadow],
        color: Colors.pinkAccent,
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
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
//        child: FadeInImage.assetNetwork(
//          placeholder: "images/test.JPG",
//          image: url,
//          fit: BoxFit.cover,
//        ),
      ),
    );
  }
}

Widget TitleWithGlass(newsTitle) {
  return new Container(
    child: Text(
      newsTitle,
      style: BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}

Widget TitleWithoutGlass(newsTitle) {
  return new Container(
    child: Text(
      newsTitle,
      style: BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(14, 14, 14, 0.3),
    ),
  );
}

List<Widget> BlocksKeyWords(keyWords) {
  return <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Color.fromRGBO(96, 98, 92, 0.6),
      ),
      height: 21,
      child: Center(
        child: Text(keyWords[0].toString(),
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
      child: Center(
        child: Text(keyWords[1].toString(),
            style: TextStyle(
              color: Colors.white70,
            )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
    )
  ];
}



// static fake datas
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
  Blocks("Nil", titlestext[3], keyWords),
  Blocks(Urls[0], titlestext[0], keyWords),
  Blocks(Urls[1], titlestext[1], keyWords),
  Blocks(Urls[2], titlestext[2], keyWords),
];

List<Widget> changedTitles = <Widget>[
  Blocks(Urls[2], titlestext[1], keyWords),
  Blocks(Urls[0], titlestext[2], keyWords),
  Blocks("Nil", titlestext[0], keyWords),
  Blocks(Urls[1], titlestext[3], keyWords),
];

List<String> titlestext = <String>[
  "this is the fucking title",
  "lover~ fucker~",
  "do you fell cold and lost in desperation?",
  "you build up hope and failures all you know,remember all the sadness and frustration,and let it go,let it go"
];

List<String> Urls = <String>[
  "https://ss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=575b36d70d3b5bb5a1d726fe06d2d523/a6efce1b9d16fdfad03ef192ba8f8c5494ee7b7f.jpg",
  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555349644378&di=cd5a913a50105a2c5edb80883c38bf19&imgtype=0&src=http%3A%2F%2Fimg.sgamer.com%2Fwww_sgamer_com%2Fimages%2F190312%2F42ce769a83c98fdd8e8d54ef4591a122.jpg",
  "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1757326236,2029116386&fm=26&gp=0.jpg"
];

List<String> keyWords = <String>["key1", "key2"];
