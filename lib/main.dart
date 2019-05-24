import 'package:flutter/material.dart';
import 'globals.dart' show files;
import 'package:webview_flutter/webview_flutter.dart';
import 'menu.dart';


final primaryColor = Color(0xFFC41949);
final secondaryColor = Color(0xFF6bc048);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    files = Map(); //COME BACK HERE AND TIDY UP
    print("Creating Material App");
    return MaterialApp(
      title: 'HSS',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: MenuView(),
    );
  }
}



class HomeViewState extends State<HomeView>{
  // @override
  // void dispose(){
  //   super.dispose();
  // }
  WebViewController _controller;
  final String html = '''<html>
<head><meta name="viewport" content="width=device-width; height=device-height;"><link rel="stylesheet" href=""><link rel="stylesheet" href=""><link rel="stylesheet" href=""><title>(JPEG Image, 1280&nbsp;×&nbsp;720 pixels)</title></head><body><img class="shrinkToFit" src="http://192.168.0.26:8081/" alt="http://192.168.0.26:8081/"></body>
</html>''';

  @override
  Widget build(BuildContext context){
    return WebView(
      onWebViewCreated: (WebViewController c){
        _controller = c;
      },
      initialUrl: 'http://192.168.0.26:8081/',
    );
  }
}


class HomeView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>HomeViewState();
}
