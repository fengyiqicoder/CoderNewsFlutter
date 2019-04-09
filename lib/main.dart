import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material 是UI呈现的“一张纸”
    return new Material(
      // Column is 垂直方向的线性布局.
      child: new Scaffold(
//          appBar: AppBar(
//            title: Text("Rock"),
//          ),
          body: new StaggeredGridView.countBuilder(
            crossAxisCount: 5,
            itemCount: 9,
            itemBuilder: (BuildContext context, int index) => new Container(
                color: Colors.green,
                child: new Center(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text('$index'),
                  ),
                )),
            staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
      ),
    );
  }
}

class Echo extends StatelessWidget {
  const Echo({
    Key key, //隐式调用
    @required this.text,
    this.backgroundColor,
  }) : super(key: key);
  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

//Statefull Widget
class CounterWidget extends StatefulWidget {
  const CounterWidget({
    Key key,
    this.initValue: 0,
  });
  final int initValue;

  @override
  _CounterWidgetState createState() => new _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化
    _counter = widget.initValue;
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("build");
    return Center(
      child: FlatButton(
          onPressed: () =>
              setState(() => ++_counter), //使用setState()来重新调用Build方法
          child: Text('$_counter')),
    );
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactive");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

//widget父类管理状态
class Parent extends StatefulWidget {
  @override
  ParentState createState() {
    // TODO: implement createState
    return ParentState();
  }
}

class ParentState extends State<Parent> {
  bool active = false;

  void handler(bool value) {
    setState(() {
      active = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: TapboxB(
        tapHandler: handler,
        active: active,
      ),
    );
  }
}

//子类 stateless wiget

class TapboxB extends StatefulWidget {
  TapboxB({
    this.active,
    this.tapHandler,
  });

  bool active;
  ValueChanged<bool> tapHandler;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TapboxBState();
  }
}

class TapboxBState extends State<TapboxB> {
  bool highLight = false;
  void tap() {
    widget.tapHandler(!widget.active);
  }

  void tapUp(TapUpDetails details) {
    setState(() {
      highLight = false;
    });
  }

  void tapDown(TapDownDetails details) {
    setState(() {
      highLight = true;
    });
  }

  void handleTapCancel() {
    setState(() {
      highLight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    print("Build");
    return new GestureDetector(
      onTap: tap,
      onTapUp: tapUp,
      onTapDown: tapDown,
      onTapCancel: handleTapCancel,
      child: Container(
        child: Center(
          child: Text(
            widget.active ? "Active" : "inActive",
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightBlue : Colors.grey,
          border: highLight
              ? new Border.all(
                  color: Colors.teal[700],
                  width: 10.0,
                )
              : null,
        ),
      ),
    );
  }
}

//widget管理自身状态

class TapboxA extends StatefulWidget {
  @override
  TapboxAState createState() {
    return new TapboxAState();
  }
}

class TapboxAState extends State<TapboxA> {
  bool _active = false;

  void tap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: tap,
      child: Container(
        child: Center(
          child: Text(
            _active ? "Active" : "inActive",
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200,
        height: 200,
        decoration:
            BoxDecoration(color: _active ? Colors.lightBlue : Colors.grey),
      ),
    );
  }
}

//ListView

class ListView1 extends StatelessWidget {
  Widget divider1 = Divider(color: Colors.amberAccent);
  Widget divider2 = Divider(color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        },
        separatorBuilder: (BuildContext context, int index) {
          return index % 2 == 0 ? divider1 : divider2;
        },
        itemCount: 100);
  }
}

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => new _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 300) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0)
              ),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
            );
          }
        }
        //显示单词列表项
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      _words.insertAll(_words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
      );
      setState(() {
        //重新构建列表
      });
    });
  }

}

void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: new MyScaffold(),
  ));
}
