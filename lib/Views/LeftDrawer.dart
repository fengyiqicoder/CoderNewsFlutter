import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:helloflutter/Views/KeyWordsPage.dart';
import '../models/MainScreenModel.dart';

const double _kWidth = 200;
MainModel model;
List<String> drawerList = [];
class LeftDrawer extends StatefulWidget{
  LeftDrawer(themodel){
    model = themodel;
    drawerList = model.currentCategoryArray;
  }
  @override
  State<StatefulWidget> createState() =>LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer> {

  LeftDrawerState({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.color = Colors.transparent,
  });


  final double elevation;

  final Widget child;

  final String semanticLabel;

  final Color color;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: _kWidth),
        child: Material(
          color: color,
          elevation: elevation,
          child: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: window.physicalSize.height.toDouble() / window.devicePixelRatio.toDouble() - 150,

                    child: ListView(
                      itemExtent: 40,
                      children: createDrawerKeyLable(drawerList),
                    ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            color: Colors.pinkAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return KeyWordsPage(this,drawerList,model);
                              }));
                            },
                          ),
                          Text("Add key")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> createDrawerKeyLable(List<String> drawerKeyList){
  int n = drawerKeyList.length;

  List<Widget> result = [];

  for(int i = 0; i < n; i ++){
    result.add(
      Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color.fromRGBO(14, 14, 14, 0.1)))
        ),
        child: Center(
          child: Text(
            drawerKeyList[i],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      )
    );
  }

  return result;
}



