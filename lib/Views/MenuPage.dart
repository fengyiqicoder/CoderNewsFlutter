import 'package:flutter/material.dart';
import 'dart:ui';
import 'FavorPage.dart';

BuildContext menuContext;

class FloatButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FloatButtonState();
}

class FloatButtonState extends State<FloatButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 13,
      height: 50,
      child: new Hero(
        tag: "Menu",
        child: new RaisedButton(
        shape: CircleBorder(),
          child: Icon(
            Icons.more_horiz,
            size: 33,
          ),
          color: Colors.pinkAccent,
          textColor: Colors.white70,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MenuPage();
            }));
          },
        ),
      )
    );
  }

}

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    menuContext = context;
    return Hero(
      tag: "Menu",
      child: Scaffold(
        body: Container(
          child: Container(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0
              ),
              children: MenuButtons,
            ),
            color: Color.fromRGBO(14, 14, 14, 0.3),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber[600],
                Colors.greenAccent,
                Colors.lightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      )
    );
  }
}

List<Widget> MenuButtons = [
  FlatButton(
    child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.home),
        Text("主页"),
      ],
    ),
    onPressed: (){
      Navigator.pop(menuContext);
    },
  ),

  FlatButton(
    child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.view_list),
        Text("Tops"),
      ],
    ),
    onPressed: (){},
  ),

  FlatButton(
    child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.person),
        Text("Self"),
      ],
    ),
    onPressed: (){},
  ),

  FlatButton(
    child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.favorite),
        Text("我赞过的"),
      ],
    ),
    onPressed: (){
      Navigator.of(menuContext).push(MaterialPageRoute(builder: (menuContext) {
        return FavorPage();
      }));
    },
  ),

  FlatButton(
    child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.settings_ethernet),
        Text("设置"),
      ],
    ),
    onPressed: (){},
  ),
];
