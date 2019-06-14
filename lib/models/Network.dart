import 'package:dio/dio.dart';

Future<Map> getMainScreenDatas(List<String> categoryArray,int infoAmount,List<int> queueHeadArray) async {//加入函数
    const url = "http://gianttough.cn/coder_news/find/?";// Android 10.0.2.2  Apple 127.0.0.1
//    const url = "http://10.0.2.2:8000/find/?";
//    const url = "http://127.0.0.1:8000/find/?";
    Dio dio = new Dio();
    var categoryArrayString = "[";
    for (var index = 0;index < categoryArray.length;index++){
        var name = categoryArray[index];
        if (index != categoryArray.length-1) {
            categoryArrayString += name + ",";
        }else{
            categoryArrayString += name + "]";
        }
    }
    var queueHeadString = "[";
    for (var index = 0;index < queueHeadArray.length;index++){
        var name = queueHeadArray[index];
        if (index != queueHeadArray.length-1) {
            queueHeadString +=  "$name,";
        }else{
            queueHeadString += "$name]";
        }
    }
    print("getDatas $url");
    print(categoryArrayString);
    Response response = await dio.get(url,queryParameters: { "categoryArray":categoryArrayString,"infoAmount":infoAmount,"queueHeadArray":queueHeadString });
    //转换为JSON
    return response.data;
}


Future<Map> getFavoriteTitle(List<String> articleUrl) async{
    const url = "http://gianttough.cn/coder_news/findByUrl/?";
    Dio dio = new Dio();
    var articleUrlString = "[";
    for (var index = 0; index < articleUrl.length; index++) {
        var article = articleUrl[index];
        if(index != articleUrl.length-1) {
            articleUrlString += article + ",";
        } else {
            articleUrlString += article + "]";
        }
    }
    Response response = await dio.get(url, queryParameters: {"urlList":articleUrlString});
    return response.data;
}

//检查URL

String checkUrl(String str){//把#改成%23
    var finalString = str;
    var index = str.indexOf("#");
    print(index);
    while (index != -1) {
        finalString = replaceCharAt(finalString, index, "%23");
        index = finalString.indexOf("#");
    }
    return finalString;
}

String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
}






