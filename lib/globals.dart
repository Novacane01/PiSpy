library pi_spy.globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

Map<String,List<File>> files;

List<Future<http.Response>> _getFiles(){
  print('making request');
  return [http.get('http://192.168.0.26:7070/camera/images'),http.get('http://192.168.0.26:7070/camera/videos')];
}

Future<http.Response> getCameraStatus(){
  return http.get('http://192.168.0.26:7070/status');
}

Future<http.Response> deleteFile(String file){
  return http.delete('http://192.168.0.26:7070/camera/files$file');
}

Future<bool> loadFiles()async{
    print('Getting images');
    await _getFiles()[0].then((res){
      print('here');
      if(res.statusCode==200){
        Iterable _images = jsonDecode(res.body);
        files['images'] = (_images.map((dynamic image){
          print(image.toString());
          return Img(image.toString(), Image.network('http://192.168.0.26:7070/files/'+image.toString(),fit: BoxFit.fill,));
        }).toList());
      }
      print('Getting videos');
      _getFiles()[1].then((res){
        if(res.statusCode==200){
          Iterable _videos = jsonDecode(res.body);
          files['videos'] = (_videos.map((dynamic video){
            print(video.toString());
            return Vid(video.toString(), VideoPlayerController.network('http://192.168.0.26:7070/files/'+video.toString(),)
            ..initialize());
          }).toList());
          print('setting stuff');
        }
      },onError: (e){
        throw e;
      });
    },onError: (e){
      throw e;
    });
    return true;
  }

abstract class File{
  final String type;
  final String name;
  File(this.name, this.type);
}

class Img extends File{
  final Image img;
  Img(String name,this.img):super(name,'image');
}

class Vid extends File{
  final VideoPlayerController vid;
  Vid(String name,this.vid):super(name,'video');
}