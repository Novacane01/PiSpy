library pi_spy.file;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';


Map<String,Map<String,File>> files;

//Retrieves the names of all files from server
List<Future<http.Response>> _getFiles(){
  print('making request');
  return [http.get('http://192.168.0.26:7070/camera/images'),http.get('http://192.168.0.26:7070/camera/videos')];
}

//Gets camera status (Enabled/Disabled)
Future<http.Response> getCameraStatus(){
  return http.get('http://192.168.0.26:7070/status').timeout(Duration(seconds: 5),onTimeout: ()=>throw Error());
}

//Deletes specified file from raspeberry pi
Future<http.Response> deleteFile(File file) async{
  files[file.type].remove(file.name);
  if(file.type=='video'){
    await (file as Vid).vid.dispose(); //Dispose of video controller before deleting
  }
  return http.delete('http://192.168.0.26:7070/camera/files/${file.name}');
}

//Retrieves files from server and loads them into app
Future<List> loadFiles() async{
    print('Getting images');
    Future imageFuture =  _getFiles()[0].then((res){ //Retrieves all images from raspberry pi
      if(res.statusCode==200){
        List _images = jsonDecode(res.body);
        _images.sort();

        if((files['image']?.length ?? 0) == 0){ //Checks to see if any images have already been loaded
          Map<String,File> _imageMap = Map<String,File>();
          print('mapping images');
          for(String image in _images){
            _imageMap[image] = Img(image, Image.network('http://192.168.0.26:7070/files/'+image,fit: BoxFit.fill,));
          }
          files['image'] = _imageMap;
        }
        else{
         for(String image in _images){
            if(!files['image'].containsKey(image)){
              files['image'][image] = Img(image, Image.network('http://192.168.0.26:7070/files/'+image,fit: BoxFit.fill,));
            }
         }
        } 
      }
    },onError: (e){
      throw e;
    });
    Future videoFuture = _getFiles()[1].then((res) async{ //Retrieves all videos from raspberry pi
      if(res.statusCode==200){
        List _videos = jsonDecode(res.body);
        _videos.sort();
        
        List<Future> _videoFutures = [];
        if((files['video']?.length ?? 0) == 0){ //Checks to see if any videos have already been loaded
          Map<String,File> _videoMap = Map<String,File>();
          for(String video in _videos){
            _videoMap[video] = Vid(video, VideoPlayerController.network('http://192.168.0.26:7070/files/'+video,)); //Creates Vid object and initializes the controller
          }
          files['video'] = _videoMap;
          for(Vid v in files['video'].values.toList()){
            _videoFutures.add(v.vid.initialize());
          }
        }
        else{ //If files has already been initialized, check for any new videos and initialize them
          for(String video in _videos){
            if(!files['video'].containsKey(video)){
              files['video'][video] = Vid(video, VideoPlayerController.network('http://192.168.0.26:7070/files/'+video,));
              _videoFutures.add((files['video'][video] as Vid).vid.initialize());
            }
          }
        }
        await Future.wait(_videoFutures);
      }
      return true; 
    },onError: (e){
      throw e;
    });
    return Future.wait([videoFuture,imageFuture]);
  }

//File abstract class
abstract class File{
  final String type;
  final String name;
  File(this.name, this.type);
}

//Image class
class Img extends File{
  final Image img;
  Img(String name,this.img):super(name,'image');
}

//Video class
class Vid extends File{
  final VideoPlayerController vid;
  Vid(String name,this.vid):super(name,'video');
}