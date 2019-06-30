import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//LIVESTREAM STUFF

class StreamViewState extends State<StreamView>{
  @override
  Widget build(BuildContext context){
    return Container(
      child:WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'http://192.168.0.26:7070/stream',
      ),
    );
  }
}


class StreamView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>StreamViewState();
}
