import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'files.dart';
import 'package:video_player/video_player.dart';
import 'globals.dart';

class EnableCameraState extends State<EnableCamera>{
  bool _isCameraEnabled = false;
  @override
  Widget build(BuildContext context){
    print('Creating ListView');
    return camMenu(context);
  }
  Future<http.Response> _updateCameraStatus(){
    return _isCameraEnabled ? http.post('http://192.168.1.24:7070/camera/enable'):http.post('http://192.168.1.24:7070/camera/disable') ;
  }
  List<Future<http.Response>> _getFiles(){
    return [http.get('http://192.168.1.24:7070/camera/images'),http.get('http://192.168.1.24:7070/camera/videos')];
  }
  void listener(){
    setState(() {
      
    });
  }
  void _showFiles(){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context){
        return FilesView();
      },
    ),);
  }
  Widget camMenu(BuildContext context){
    print('Doing ListView stuff');
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Camera Name'),
          trailing: Text('Rasperry Pi'),
        ),
        Divider(height: 4.0,),
        ListTile(
          title: Text('Enable Camera'),
          trailing: Switch(
            value: _isCameraEnabled,
            onChanged: (bool newValue){
              setState(() {
                _isCameraEnabled = newValue;
              });
              _updateCameraStatus();
            },
            activeColor: Colors.lightBlueAccent,
          ),
        ),
        Divider(height: 4.0,),
        ListTile(
          title: Text('View Files'),
          onTap: (){
            _getFiles()[0].then((res){
              if(res.statusCode==200){
                Iterable _images = jsonDecode(res.body);
                setState(() {
                  files['images'] = (_images.map((dynamic image){
                    print(image.toString());
                    return Img(image.toString(), Image.network('http://192.168.1.24:7070/files/'+image.toString(),fit: BoxFit.fitWidth,));
                  }).toList());
                });
              }
              _getFiles()[1].then((res){
                if(res.statusCode==200){
                  Iterable _videos = jsonDecode(res.body);
                  setState(() {
                    files['videos'] = (_videos.map((dynamic video){
                      print(video.toString());
                      return Vid(video.toString(), VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',)
                      ..initialize());
                    }).toList());
                    _showFiles();
                  });
                }
              },onError: (e){
                throw e;
              });
            },onError: (e){
              throw e;
            });
          },
        ),
        Divider(height: 4.0,),
      ],
    );
  }
}

class EnableCamera extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>EnableCameraState();
}

abstract class File{
  final String type;
  final String name;
  File(this.name, this.type);
}

class Img extends File{
  final Image img;
  Img(String name,[this.img]):super(name,'image');
}

class Vid extends File{
  final VideoPlayerController vid;
  Vid(String name,[this.vid]):super(name,'video');
}