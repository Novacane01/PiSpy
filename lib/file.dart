import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';


Map<String,Map<String,File>> files = Map();
http.Client client = http.Client();

//Retrieves the names of all files from server
Future<List<http.Response>> _getFiles() async{
  print('making request');
  try{
    http.Response imagesGet = await client.get('http://24.250.172.18:6890/camera/images');
    http.Response videosGet = await client.get('http://24.250.172.18:6890/camera/videos');
    return Future.value([imagesGet,videosGet]);
  }catch(e){
    print(e);
    return Future.error(e);
  }
}

//Gets camera status (Enabled/Disabled)
Future<http.Response> getCameraStatus() async{
  try{
    print('getting status');
    http.Response cameraStatus = await client.get('http://24.250.172.18:6890/status').timeout(Duration(seconds: 5));
    return cameraStatus;
  }catch(e){
    print(e);
    return Future.error(e);
  }
}

//Deletes specified file from raspeberry pi
Future<http.Response> deleteFile(File file) async{
  files[file.type].remove(file.name);
  if(file.type=='video'){
    await (file as Vid).vid.dispose(); //Dispose of video controller before deleting
  }
  return client.delete('http://24.250.172.18:6890/camera/files/${file.name}');
}

//Retrieves files from server and loads them into app
Future<List> loadFiles(){
    print('Getting images');

    return _getFiles().then((list) async{
      Future loadImages = Future((){
        http.Response imageResponse = list[0]; //Retrieves all images from raspberry pi
        if(imageResponse.statusCode==200){
          List _images = jsonDecode(imageResponse.body);
          _images.sort();

          if((files['image']?.length ?? 0) == 0){ //Checks to see if any images have already been loaded
            Map<String,File> _imageMap = Map<String,File>();
            print('mapping images');
            for(String image_name in _images){
              _imageMap[image_name] = Img(image_name, Image.network('http://24.250.172.18:6890/files/'+image_name,fit: BoxFit.fill,));
            }
            files['image'] = _imageMap;
          }
          else{
            for(String image in _images){
                if(!files['image'].containsKey(image)){
                  files['image'][image] = Img(image, Image.network('http://24.250.172.18:6890/files/'+image,fit: BoxFit.fill,));
                  print('adding image');
                }
            }
          }
        }
        return true;
      });
      
      Future loadVideos = Future((){
        http.Response videoResponse = list[1];
        List<Future> _videoFutures = [];
        if(videoResponse.statusCode==200){
          List _videos = jsonDecode(videoResponse.body);
          _videos.sort();
          
          if((files['video']?.length ?? 0) == 0){ //Checks to see if any videos have already been loaded
            Map<String,File> _videoMap = Map<String,File>();
            for(String video in _videos){
              print(video);
              _videoMap[video] = Vid(video, VideoPlayerController.network('http://24.250.172.18:6890/files/'+video,)); //Creates Vid object and initializes the controller
            }
            files['video'] = _videoMap;
            for(Vid v in files['video'].values.toList()){
              _videoFutures.add(v.vid.initialize());
              print('adding video');
            }
          }
          else{ //If files has already been initialized, check for any new videos and initialize them
            for(String video_name in _videos){
              if(!files['video'].containsKey(video_name)){
                files['video'][video_name] = Vid(video_name, VideoPlayerController.network('http://24.250.172.18:6890/files/'+video_name,));
                _videoFutures.add((files['video'][video_name] as Vid).vid.initialize());
              }
            }
          }
        }
        return true;
      });
      
      return Future.wait([loadImages,loadVideos]);
    },onError: (e){
      throw e;
    });      
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