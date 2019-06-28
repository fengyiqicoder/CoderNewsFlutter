import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/MainScreenModel.dart';


MainModel mainModel;
String theUrl;
class NavigationControls extends StatelessWidget {
  NavigationControls(this._webViewControllerFuture, this.url ,model){
    mainModel = model;
    theUrl = url;
  }
  final Future<WebViewController> _webViewControllerFuture;
  final String url;



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
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {navigate(context, controller, goBack: true);},
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
      controller.goBack();
    } else {
      Navigator.pop(context);
    }
  }
}

class Menu extends StatelessWidget {
  Menu(this._webViewControllerFuture, this.url)
      :assert(_webViewControllerFuture != null),
        assert(url != null);
  final Future<WebViewController> _webViewControllerFuture;
  final String url;

  @override
  Widget build(BuildContext context) {

        return PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>> [
            const PopupMenuItem(
              value: "share",
              child: Text("分享"),
            ),
            const PopupMenuItem(
              value: "openInBrowser",
              child: Text("在浏览器中打开"),
            )
          ],
          onSelected: (String value) async {
            if(value == "share") {
              print(url);
              Share.share(url);
            }
            if(value == "openInBrowser") {
              print(url);
              launch(url);
            }
          },
        );

  }

}

class FavoriteButton extends StatefulWidget {
  FavoriteButton(this.isFavorite, this.color)
      :assert(isFavorite != null),
        assert(color != null);

  bool isFavorite;
  Color color;

  @override
  _FavoriteWidgetState createState() => new _FavoriteWidgetState(this.isFavorite, this.color);

}

class _FavoriteWidgetState extends State<FavoriteButton> {
  _FavoriteWidgetState(this.isFavorite, this.color)
      :assert(isFavorite != null),
        assert(color != null);

  bool isFavorite;
  Color color;

  void initState() {
    mainModel.getArray();
    if(mainModel.likedArray.contains(theUrl)) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
  }



  void setFavorite() {
    setState(() {
      if(isFavorite == false) {
        isFavorite = true;
        //添加到model里
        mainModel.likedArray.add(theUrl);
        mainModel.saveArrays();
      }
      else {
        isFavorite = false;
        //删除model里
        mainModel.likedArray.removeLast();
        mainModel.saveArrays();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      child: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onPressed: setFavorite,
      backgroundColor: color,
    );
  }

}