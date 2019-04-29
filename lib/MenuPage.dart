import 'package:flutter/material.dart';

class FloatButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FloatButtonState();
}

class FloatButtonState extends State<FloatButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        ));
  }
}

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Hero(
      tag: "Menu",
      child: Container(
        child: Container(
          child: Text(
            "Menu",
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
    );
  }
}
