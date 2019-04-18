import 'package:dio/dio.dart';

Future<Map> getMainScreenDatas(List<String> categoryArray,int infoAmount,List<int> queueHeadArray) async {//加入函数
//    const url = "http://127.0.0.1:8000/find/?";// Android 10.0.2.2  Apple 127.0.0.1
//    const url = "http://10.0.2.2:8000/find/?";
    const url = "http://gianttough.cn/coder_news/find/?";
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
    Response response = await dio.get(url,queryParameters: { "categoryArray":categoryArrayString,"infoAmount":infoAmount,"queueHeadArray":queueHeadString });
    //转换为JSON
    return response.data;
}






