import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pi_spy/helpers/file.dart';
import 'package:http/http.dart' as http;


//LIVESTREAM STUFF

class StreamViewState extends State<StreamView>{
  @override
  Widget build(BuildContext context){
    //Check to see if camera is enabled or not
    return FutureBuilder(
      future: getCameraStatus(),
      builder: (context, AsyncSnapshot<http.Response> snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text('There was an error connecting to the camera',
             style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        if(snapshot.hasData){
          if(snapshot.data.body == 'false'){
            return Center(
              child: Text('Camera must be enabled to view livestream',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          else{
            return Container(
              child:WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: (mode=='development')?'http://24.250.168.190:6890/stream':'http://192.168.1.8:7070/stream',
              ),
            );
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


class StreamView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>StreamViewState();
}
