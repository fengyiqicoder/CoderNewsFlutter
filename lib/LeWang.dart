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
  static const buttomColor = Color.fromRGBO(252, 92, 137, 0.9);
}

var ScreenSize = window.physicalSize; //real px
var Pixel = window.devicePixelRatio;
var PaddingTopSize = window.padding.top;

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
  AnimationController _controller;
  Animation<double> _animation;

  double _deltas;
  double _begin;
  double _end;
  double _maxWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      duration: Duration(microseconds: 1),
      vsync: this,
    );

    _maxWidth = ScreenSize.width.toDouble() / Pixel - 80; //位移给定的范围
    _begin = 1; //动画的开始
    _end = 1; //动画的技术
    _deltas = 0; //手势的位移
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // fit screen datas
    var WidgetHeight = (ScreenSize.width.toDouble() / 2) * 3;
    var PaddingSize = (ScreenSize.height.toDouble() - WidgetHeight + PaddingTopSize.toDouble()) / 2 / Pixel;

    // animation datas
    _animation = Tween(begin: _begin,end: _end).animate(_controller); //定义动画
    _controller.forward();

    return new Scaffold(
      body: GestureDetector(
        child: Opacity(
          opacity: _animation.value,
          child: Stack(
            children: <Widget>[
              new StaggeredGridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                staggeredTiles: counter ? _staggeredTitles : _staggeredTitles1,
                //the style of the blocks
                children: counter ? titles : changedTitles,
                // the information of the blocks
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(vertical: PaddingSize, horizontal: 8),
              ),
              new Positioned(
                bottom: 13,
                left: 3,
                height: 60,
                child: new RaisedButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.list,size: 33,),
                  onPressed: onTapFloatButton,
                  color: DefaultTheme.buttomColor,
                  textColor: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        onHorizontalDragStart: (DragStartDetails startDetails) {
          print(startDetails.toString());
        },
        onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
          _deltas = updateDetails.delta.dx + _deltas; //记录手势位移
          setState(() {
            if(_deltas < 0 && _deltas.abs() < _maxWidth){ //判断位移的方向并确定滑动距离没有超过给定的范围
                                                          //需要增加判断条件，判断是否超出给定范围，如果超过给定范围需要调用刷新
              _begin = _end;
              _end = 1 - _deltas.abs() / _maxWidth; //对动画的起止位置进行赋值
              print("begin: $_begin");
              print("end: $_end");
            }
          });
        },
        onHorizontalDragEnd: (DragEndDetails endDetails) {
          _begin = 1;
          _end = 1;
          _deltas = 0; //手势监听结束对动画的值初始化 此处需要加入监听条件，如果滑动速度超过给定值需要调用刷新
                       //实现方法：判断endDetails.velocity是否大于给定值
          setState(() {});
        },
      ),
    );
  }

  void onTapFloatButton() {
    print("onTapFloatButton");
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
