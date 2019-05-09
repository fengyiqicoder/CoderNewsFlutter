import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'MainScreenModel.dart';
import 'Constants.dart';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import 'MenuPage.dart';


//数据控制
var model = MainModel();
//屏幕具中和Grid平铺
var ScreenSize = window.physicalSize; //real px
var Pixel = window.devicePixelRatio;
var PaddingTopSize = window.padding.top;
var screenRatio = ScreenSize.height / ScreenSize.width;
var gridHeightIs4 = screenRatio > Constants.changeGridTo4x2Radio;

class BlockPage extends StatefulWidget {
  const BlockPage({Key key});

  @override
  BlockPageState createState() {
    return BlockPageState();
  }
}

class BlockPageState extends State<BlockPage> with TickerProviderStateMixin {
  //从Model获取数据进行展示
  List<StaggeredTile> currentTile = [];
  List<Blocks> currentWidgets = [];

  //Animations
  AnimationController _controller;
  Animation<double> _animation;
  double _deltas;
  double widthToUpdate;
  double opacity = 1.0;
  bool isGettingNewData = false;
  var position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    //在这里获取网络数据
    getDatasForView();
    //获取本地数据代码 暂时不使用
//    model.getArray().then((nothing){//获取本地数据之后才能获取网络数据
//      print("创建State只有一次");
//      //在这里获取网络数据
//      getDatasForView();
//    });
    print("initState");
    //animations
    _controller = AnimationController(
      duration: Duration(milliseconds: Constants.animationTimeForSwipeGesture),
      vsync: this,
    );

    widthToUpdate = (ScreenSize.width.toDouble() / Pixel) *
        Constants.widthToUpdateRadioToScreen; //位移给定的范围
    _deltas = 0; //手势的位移
  }

  @override
  Widget build(BuildContext context) {
//    print("屏幕信息");
//    print(screenRatio < Constants.changeGridTo4x2Radio);
    var gridHeight = gridHeightIs4 ? 4 : 3;
//    print("gridHeightIs4");
//    print(gridHeightIs4);
    var WidgetHeight = (ScreenSize.width.toDouble() / 2) * gridHeight;
    var PaddingSize = (ScreenSize.height.toDouble() -
            WidgetHeight +
            PaddingTopSize.toDouble()) /
        2 /
        Pixel;
    print("Building Page 透明度 $opacity $currentWidgets $currentTile");
    print(position);
    if (currentWidgets.length == 0) {
      print("返回空Views");
      return Scaffold(); //return emtry views
    }
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: DecoratedBox(
              child: Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: position,
                  child: StaggeredGridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      staggeredTiles: currentTile,
                      //the style of the blocks
                      children: currentWidgets,
                      // the information of the blocks
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: ConstantsForTile.axiaGap,
                      crossAxisSpacing: ConstantsForTile.axiaGap,
                      padding: EdgeInsets.symmetric(
                          vertical: PaddingSize,
                          horizontal: Constants.gridViewHorizontalGapToScreen)),
                ),
              ),
              decoration:
                  BoxDecoration(color: Constants.mainScreenBackgroundColor),
            ),
          ),
          FloatButton(),
        ],
      ),
      onHorizontalDragStart: (DragStartDetails startDetails) {
        print(startDetails.toString());
      },
      onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
        _deltas = updateDetails.delta.dx + _deltas; //记录手势位移
        if (isGettingNewData) {
          return;
        }
        setState(() {
          //更新状态
          if (_deltas < 0 && _deltas.abs() < widthToUpdate) {
            var newOpacity = 1 + _deltas / widthToUpdate;
            opacity = newOpacity;
            position = new Offset(-(1 - opacity) * widthToUpdate, 0.0);
          } else if (_deltas.abs() > widthToUpdate && _deltas < 0) {
            //刷新页面
            print("更新数据页面");
            //先查看是否在浏览历史记录
            _deltas = 0;
            if (model.oldScreenShowingIndex > 0){
              //获取上一页代码
              var oldData = model.getUpPageData();
              currentTile = oldData.item1;
              currentWidgets = oldData.item2;
            }else {
              position = Offset(0.0, 0.0);
              FreshDatas();
            }
          } else if (_deltas > 0 && _deltas.abs() < widthToUpdate){
            var newOpacity = 1 - _deltas / widthToUpdate;
            print(newOpacity);
            //根据这个东西展示UI
            opacity = newOpacity;
//            position = new Offset(-(1 - opacity) * widthToUpdate, 0.0);
          } else if (_deltas > 0 && _deltas.abs() > widthToUpdate){
            //返回之前的页面
            print("oldData.item2.first.newsTitle");
            _deltas = 0;
            var oldData = model.getDownPageData();
//            print(oldData.item2.first.newsTitle);
            if (oldData == null) {return;}
//            model.printAllOldData();
            currentTile = oldData.item1;
            currentWidgets = oldData.item2;

          }
        });
      },
      onHorizontalDragEnd: (DragEndDetails endDetails) {
        if (isGettingNewData) {
          return;
        } //判断是否正在获取数据
        print("手势结束");
        print(opacity);
        _animation = Tween(begin: opacity, end: 1.0).animate(_controller)
          ..addListener(() {
            setState(() {
              //执行动画
              opacity = _animation.value;
            });
          }); //定义动画
        _animation =
            CurvedAnimation(parent: _animation, curve: Curves.easeInOut);
        _controller.value = opacity;
        position = Offset(0.0, 0.0);
        _controller.forward(); //?直接重新build
        _deltas = 0;
        //没有达到长度才会调用这个方法
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void FreshDatas() {
    //在这里获取数据
//    currentWidgets.forEach((view) {
//      view.controller.reverse();
//    });
    isGettingNewData = true;
    print("tappingButton");
    getDatasForView();
  }

  void getDatasForView() async {
    var tileList = model.getATileList(gridHeightIs4);
    var widgetList = model.getWidgets(tileList);
    currentWidgets = await widgetList; //更新数据
    currentTile = tileList;
    //保存这两个数组
    model.saveScreenData(currentTile, currentWidgets);
    print("DataLanding");

    this.setState(() {
      //刷新页面
      print("updateViews");
      isGettingNewData = false;
      print("changeToOpactiy");
      opacity = 1.0;
    });
  }
}

class Blocks extends StatefulWidget {
  //输入一个JSON数据,自动展示这个tile
  //Build方法
  Blocks.withJson(Key key, Map jsonData, int textMaxLine, Color color)
      : super(key: key) {
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
    var newState =
        BlocksState(url, newsTitle, bgPic, tagsArray, textMaxLine, color);
    controller = new AnimationController(
        duration: const Duration(
            milliseconds: Constants.animationTimeForViewToShowUp),
        vsync: newState);
//    print("CreateController");
    newState.controller = controller;
    this.context = newState.context;
    return newState;
  }
}

class BlocksState extends State<Blocks> with SingleTickerProviderStateMixin {
  //Build方法
  BlocksState(this.url, this.newsTitle, this.bgPic, this.tagsArray,
      this.textMaxLine, this.color);

  //数据源
  var url;
  var newsTitle;
  var bgPic;
  var textMaxLine;
  var color;
  List<String> tagsArray = [];
  List<String> urlsArray= [];

  //Animation
  Animation<double> animation;
  AnimationController controller;

  // WebViewController
  Completer<WebViewController> _controller;
  //lifeCycle

  @override
  void initState() {
    super.initState();
//    print("inintState");
    animation = new Tween(begin: 0.2, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    animation = CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
    //启动动画(正向执行)
    controller.forward();
    _controller = Completer<WebViewController>();

  }

  @override
  Widget build(BuildContext context) {
//    print("BlockStateBuilding");
//    print(newsTitle);
    return Opacity(
        opacity: animation.value,
        child: GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BlocksBackgroundPic(bgPic, color),
              TitleWidget(newsTitle, textMaxLine, (bgPic != "nil")),
              Positioned(
                child: Row(
                  children: BlockKeyWords(tagsArray),
                ),
                bottom: 10.0,
                right: 10.0,
              ),
            ],
          ),
          onTap: () {
            print("url to show $url");
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new Scaffold(
                appBar: AppBar(
                    title: Text(newsTitle),
                    backgroundColor: bgPic == "" ? color : Constants.themeColor,
                    leading: NavigationControls(_controller.future),
                    actions: <Widget>[
                      Menu(_controller.future, url)
                    ],
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: bgPic == "" ? color : Constants.themeColor,
                    child: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: null
                    ),
                    onPressed: null,
                ),
                body: new WebView(
                  initialUrl: url,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              );
            }));
          },
        ));
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Widget BlocksBackgroundPic(url, color) {
  if (url == "nil" || url == "" || url == null) {
    //获取一些颜色
//    var color = Colors.pink;
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
        boxShadow: [ConstantsForTile.BlockShadow],
        color: color,
      ),
    );
  } else {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
        boxShadow: [ConstantsForTile.BlockShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
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

Widget TitleWidget(newsTitle, maxLine, withShadow) {
  //这个方法和下一个方法合成一个 等待重构
  var shadow = BoxDecoration(
    borderRadius: BorderRadius.circular(ConstantsForTile.tileRadio),
    color: Color.fromRGBO(14, 14, 14, 0.3),
  );
  return new Container(
    child: Text(
      newsTitle,
      style: ConstantsForTile.BlockTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
    ),
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
    decoration: withShadow ? shadow : null,
  );
}

//Widget TitleWithoutGlass(newsTitle, maxLine) {
//  return new Container(
//    child: Text(
//      newsTitle,
//      style: ConstantsForTile.BlockTitleTextStyle,
//      overflow: TextOverflow.ellipsis,
//      maxLines: maxLine,
//    ),
//    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
//    decoration: BoxDecoration(
//      borderRadius: BorderRadius.circular(20),
//      color: Color.fromRGBO(14, 14, 14, 0.3),
//    ),
//  );
//}

List<Widget> BlockKeyWords(List<String> keywordArray) {
  List<Widget> keyWordList = [];
  for (var tagName in keywordArray) {
    var widget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Constants.keywordShadowColor,
      ),
      height: 21,
      child: Center(
        child: Text(
          tagName,
          style: Constants.keywordFontWeight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
    keyWordList.add(widget);
  }
  return keyWordList;
}

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
    return new Scaffold(
      body: Center(
        child: Text(id.toString()),
      ),
    );
  }
}


class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady ? null : () => navigate(context, controller, goBack: true),
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
    goBack ? await controller.canGoBack() : await controller.canGoForward();
    var url = await controller.currentUrl();
    print(url);
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
        Navigator.pop(context);
    }
  }
}

class Menu extends StatelessWidget {
  Menu(this._webViewControllerFuture, this.url);
  final Future<WebViewController> _webViewControllerFuture;
  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _webViewControllerFuture,
        builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
          if(!controller.hasData) return new Container();
          return PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>> [
                const PopupMenuItem(
                    value: "分享",
                    child: Text("分享"),
                ),
                const PopupMenuItem(
                    value: "在浏览器中打开",
                    child: Text("在浏览器中打开"),
                )
              ],
            onSelected: (String value) async {
                var currentUrl = await controller.data.currentUrl();
                if(value == "分享") {
                  print(currentUrl);
                  Share.share(currentUrl);
                }
                if(value == "在浏览器中打开") {
                  print(currentUrl);
                  launch(currentUrl);
                }
            },
          );
        },
    );
  }

}