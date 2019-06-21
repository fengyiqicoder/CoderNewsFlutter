import 'package:flutter/material.dart';
import '../../models/Constants.dart';


class SettingColorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingColorPageState();
}

class SettingColorPageState extends State<SettingColorPage>{

  SettingColorPageState();

  String currentColor;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    scaffoldthis = this;
    return Scaffold(
      appBar: AppBar(
        title: Text("更改主题颜色"),
        backgroundColor:  themeColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0
              ),
              children: createColorCard(),
            )
          ],
        ),
      ),
    );
  }
}

var scaffoldthis;

class ColorCard extends StatefulWidget{
  ColorCard(this.colorName,this.colorValue);

  String colorName;
  Color colorValue;

  @override
  State<StatefulWidget> createState() => ColorCardState(colorName,colorValue);
}

class ColorCardState extends State<ColorCard>{
  ColorCardState(this.colorName,this.colorValue);

  String colorName;
  Color colorValue;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: InkWell(
        child: Center(child: Text(this.colorName),),
        onTap: () {
          setState(() {
            themeColor = this.colorValue;
          });
          print(themeColor);
          scaffoldthis.setState(() {});
        },
      ),
      color: this.colorValue,
    );
  }
}

List<Widget> createColorCard() {
  int n = ConstantsForTile.colorsList.length;
  List<Widget> result = [];

  for(int i = 0; i < n; i++){
    result.add(ColorCard(i.toString(), ConstantsForTile.colorsList[i]));
  }

  return result;
}

Color themeColor = Colors.blue;

