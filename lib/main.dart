import 'package:flutter/material.dart';
import 'globals.dart' show files;
import 'package:http/http.dart' as http;
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





// class HomeView extends StatelessWidget{
//   String html = '''<head><meta name="viewport" content="width=device-width; height=device-height;"><link rel="stylesheet" href="resource://content-accessible/ImageDocument.css"><link rel="stylesheet" href="resource://content-accessible/TopLevelImageDocument.css"><link rel="stylesheet" href="chrome://global/skin/media/TopLevelImageDocument.css"><title>(JPEG Image, 1280&nbsp;×&nbsp;720 pixels) - Scaled (96%)</title></head><body><img src="http://192.168.0.26:8081/" alt="http://192.168.0.26:8081/" class="shrinkToFit" width="1233" height="694"></body>''';
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(),
//       body:new Center(
//           child: new HtmlView(data: html),
//         ),
//     );
//   }
// }
