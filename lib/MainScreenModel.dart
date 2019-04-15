import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Network.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'BlockPage.dart';

class MainModel{

  //获取数据颜色
  var currentTilesIndex = 0;
  var currentTilesColorIndex = 0;

  var currentCategoryArray = ["swift","python"];
  var currentQueueHeadArray = [1,1];
  //获取tiles
  List<StaggeredTile> getATileList(){
    var constantsLength = ConstantsForTile.staggeredTiles6by2.length;
    if (currentTilesIndex < constantsLength){
      var result = ConstantsForTile.staggeredTiles6by2[currentTilesIndex];
      currentTilesIndex = currentTilesIndex == constantsLength-1 ? 0 : currentTilesIndex+1 ;
      return result;
    }else{
      print("currentTilesConstants报错");
    }
  }
  //获取颜色
  Color getATileColor(){
    var constantsLength = ConstantsForTile.colorsList.length;
    if (currentTilesColorIndex < constantsLength){
      var result = ConstantsForTile.colorsList[currentTilesColorIndex];
      currentTilesColorIndex = currentTilesColorIndex == constantsLength-1 ? 0 : currentTilesColorIndex+1 ;
      return result;
    }else{
      print("currentTilesColorIndex报错");
    }
  }
  //获取Widgets
  Future<List<Widget>> getWidgets(amount) async {
    var rawJson = await getMainScreenDatas(currentCategoryArray, amount, currentQueueHeadArray);
    var jsonArray = rawJson["data"];
    List<Widget> result = [];
    for (var data in jsonArray){
      //队首进行更新 只能处理单个标签的情况
      var tagName = data["infoId__category"];
      for (var index = 0;index < currentCategoryArray.length;index++){
        var categoryName = currentCategoryArray[index];
        if (categoryName == tagName) {
          currentQueueHeadArray[index]++;
          break;
        }
      }
//      print(tagArray is String);
      var widget = Blocks.withJson(data);
      result.add(widget);
    }
    //更新
    return result;
  }


}


