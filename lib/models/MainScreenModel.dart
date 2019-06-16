import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helloflutter/models/Network.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import '../Views/BlockPage.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel{

  //获取数据颜色
  var currentTilesIndex = 0;
  var currentTilesColorIndex = 0;
  List<String> currentCategoryArray = ["python", "swift"];
  List<int> currentQueueHeadArray = [1,1];//储存这个值
  List<String> likedArray = [];
  //关键词选择有关代码

  List<String> userChosenKeywordsList = [];

  void changeUserChosenKeywordsList(newList){
    userChosenKeywordsList = newList;
    //本地化代码
    saveArrays();
  }

  List<String> getUserChosenKeywordList(){
    return userChosenKeywordsList;
  }

  //保存数据有关代码
  //获取每次登陆时间，进行判定是否需要更新queueHead
  //

  //储存分类数组和表头数组到本地
  void saveArrays() async {
//    return;//暂时不进行储存
    SharedPreferences defualts = await SharedPreferences.getInstance();
    defualts.setStringList("currentCategoryArray", currentCategoryArray);
    defualts.setStringList("likedArray", likedArray);
    for (var index = 0;index<currentCategoryArray.length;index++){
      var key = "currentQueueHeadArray" + index.toString();
      var value = currentQueueHeadArray[index];
      defualts.setInt(key, value);
    }
    print("喜爱的数据数组");
    print(likedArray);
  }
  //获取分类数组和表头数组
  Future<Null> getArray() async{
    SharedPreferences defualts = await SharedPreferences.getInstance();
    List<int> array = [];
    currentCategoryArray = defualts.getStringList("currentCategoryArray") ?? ["python", "swift"];//如果没有应该让用户进行选择
    likedArray = defualts.getStringList("likedArray") ?? [];
    for (var index = 0;index<currentCategoryArray.length;index++){
      var key = "currentQueueHeadArray" + index.toString();
      var item = defualts.getInt(key) ?? 1 ;
      array.add(item);
    }
    currentQueueHeadArray = array;
    print("获取数据");
    print(currentCategoryArray);
    print(currentQueueHeadArray);
    print(likedArray);
  }

  void updateCategoryArray(newString){
//    for (var str in newString){
//      var doNotHave = true;
//      for (var oldStr in currentCategoryArray){
//        if (oldStr == str){
//          doNotHave = false;
//          break;
//        }
//      }
//      if (doNotHave == true){
//        currentCategoryArray.add(str);
//        currentQueueHeadArray.add(1);
//      }
//    }
    currentCategoryArray = newString;
    currentQueueHeadArray = [];
    for (var str in newString){
      currentQueueHeadArray.add(1);
    }
    print("currentQueueHeadArray");
    print(currentQueueHeadArray);
    saveArrays();
  }



  List<Tuple2<List<StaggeredTile>, List<Blocks>>> _oldScreenDatas = [];

  //为0的时候表示它没有在观看历史记录
  var oldScreenShowingIndex = 0;

//  void printAllOldData(){
//    print("Print All News Data");
//    for (var data in _oldScreenDatas){
//      print(data.item2.first.newsTitle);
//    }
//  }

  void saveScreenData(tilesArray,blocksArray){
    if (_oldScreenDatas.length == 5){
      _oldScreenDatas.removeLast();
    }
    _oldScreenDatas.insert(0, Tuple2(tilesArray, blocksArray));

    print("savedScreenOldData");
    print(_oldScreenDatas.length);
  }

  //获取上一页或者下一页的代码
  Tuple2<List<StaggeredTile>, List<Blocks>> getUpPageData(){
    if (this.oldScreenShowingIndex > 0) {
//      print("Getting Up page Datas");
      this.oldScreenShowingIndex -= 1;
//      print(oldScreenShowingIndex);
//      model.printAllOldData();
      return getOldScreenData(oldScreenShowingIndex);
    }
  }

  Tuple2<List<StaggeredTile>, List<Blocks>> getDownPageData(){
    if (this.oldScreenShowingIndex < 4) {
      this.oldScreenShowingIndex += 1;
//      print("currentIndex Of oldData");
//      print(this.oldScreenShowingIndex);
      return getOldScreenData(oldScreenShowingIndex);
    }
  }

  Tuple2<List<StaggeredTile>, List<Blocks>> getOldScreenData(index){//index只能在1~5
    return _oldScreenDatas[index];
  }

  //网络数据获取代码
  //
  //

  List<StaggeredTile> getATileList(heightIs4){
    var tileArray = heightIs4 ? ConstantsForTile.staggeredTiles4by2 : ConstantsForTile.staggeredTiles3by2;
    var constantsLength = tileArray.length;
    if (currentTilesIndex < constantsLength){
      var result = tileArray[currentTilesIndex];
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
  Future<List<Blocks>> getWidgets(List tileList) async {
    print("GetWidgets");
    var rawJson = await getMainScreenDatas(currentCategoryArray, tileList.length, currentQueueHeadArray);
    List jsonArray = rawJson["data"];
    List<Blocks> result = [];
    jsonArray.asMap().forEach((indexForData,data){
      //队首进行更新 只能处理单个标签的情况
      var tagName = data["infoId__category"];
      for (var index = 0;index < currentCategoryArray.length;index++){
        var categoryName = currentCategoryArray[index];
        if (categoryName == tagName) {
          currentQueueHeadArray[index]++;
//          print(currentQueueHeadArray);
          break;
        }
      }
      print("QueueHead");
      print(currentQueueHeadArray);
//      print(data);
      var id = data["infoId"].toString();
      var height = tileList[indexForData].mainAxisCellCount;
//      print(height);
      var color = getATileColor();
      Blocks widget = Blocks.withJson(Key(id),data,height*Constants.maxline,color);
      result.add(widget);
    });
    //更新本地数据
    saveArrays();
    return result;
  }

  Future<List<String>> getFavoriteTitle(List<String> likedUrl) async {
    var JsonData = await getFavoriteTitleData(likedUrl);
    List jsonArray = JsonData["data"];
    List<String> result = [];
    jsonArray.forEach((data){
      result.add(data["title"]);
    });
    return result;
  }

}


