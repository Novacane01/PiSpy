import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';


List<File> files = [];
http.Client client = http.Client();
const String mode = "testing";

//Retrieves the names of all files from server
Future<http.Response> _getFiles() async{
  print('making request');
  try{
    http.Response eventCodes = await client.get((mode=='development')?'http://24.250.168.190:6890/file-names':'http://192.168.1.8:7070/file-names');
    return Future.value(eventCodes);
  }catch(e){
    print(e);
    return Future.error(e);
  }
}

//Gets camera status (Enabled/Disabled)
Future<http.Response> getCameraStatus() {
    print('getting status');
    Future<http.Response> cameraStatus = client.get((mode=='development')?'http://24.250.168.190:6890/file-names':'http://192.168.1.8:7070/status').timeout(Duration(seconds: 5)).catchError((error)=>Future<http.Response>.error(error));
    return cameraStatus;
}

//Deletes specified file from raspeberry pi
Future<http.Response> deleteFile(File file) async{
  // files[file.type].remove(file.name);
  // if(file.type=='video'){
  //   await (file as Vid).vid.dispose(); //Dispose of video controller before deleting
  // }
  // return client.delete((mode=='development')?'http://24.250.168.190:6890/camera/files/${file.name}':'http://192.168.1.8:7070/camera/files/${file.name}');
}

//Retrieves files from server and loads them into app
Future loadFiles(){
  return _getFiles().then((fileList){
    print(fileList);
    List eventCodes = jsonDecode(fileList.body);
    for(String code in eventCodes){
      String videoName = 'vid_'+code+'.mp4';
      String imageName = 'img_'+code+'.jpg';
      print(imageName);
      print(videoName);
      String i = (mode=='development')?'http://24.250.168.190:6890/files/$imageName':'http://192.168.1.8:7070/files/$imageName';
      print(i);
      files.add(File(videoName, Image.network(i)));
    }
    print('done');
    return true;
  });
}

class File{
  File(this.videoName,this.image);
  String videoName;
  Image image;
  VideoPlayerController video;
}