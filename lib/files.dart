import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pi_spy/camera.dart';
import 'package:video_player/video_player.dart';
import 'camera.dart' show File,Img;
import 'globals.dart';

class FilesViewState extends State<FilesView>{
  String content = 'images';
  void _showFile(File file){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context){
        return FileView(file);
      },
    ),);
  }

  @override
  void dispose(){
    files['videos'].forEach((file){
      print('Disposing ${(file as Vid).name}');
      (file as Vid).vid.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Files'),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              iconEnabledColor: Colors.white,
            icon: Icon(Icons.dehaze),
            items: ['Images', 'Videos', 'Delete All'].map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value){
              print(value);
              setState(() {
              if(value=='Images'){
                content = 'images';
              }
              else if(value=='Videos'){
                content = 'videos';
              }
              });
            },
          ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(files!=null?files[content].length:0,(index){
          return InkWell(
            onTap: (){
              _showFile(files[content][index]);
            },
            child:Card(
              child: Container(
                  child:(content=='images')?(files[content][index] as Img).img:VideoPlayer((files[content][index] as Vid).vid,),
                  padding: EdgeInsets.only(top:18.0,bottom:18.0),
              ),
            ),
          );
        },
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }
}

class FilesView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>FilesViewState();
}

class FileViewState extends State<FileView>{
  final File _currentFile;
  FileViewState(this._currentFile);

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: (){
        print('Back button was pressed!');
        if(_currentFile.type=='video'){
          (_currentFile as Vid).vid.pause();
        }
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(_currentFile.name),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (_currentFile.type=='image')?(_currentFile as Img).img: AspectRatio(
                aspectRatio: 16/9,
                child: VideoPlayer((_currentFile as Vid).vid
                ..play())),
              ListTile(
                title: Text('Name: '),
              ),
              ListTile(
                title: Text('Date: '),
              ),
            ],
          ),
        ),
    );
  }
}

class FileView extends StatefulWidget{
  final File _currentImage;
  FileView(this._currentImage);
  @override
  State<StatefulWidget> createState()=>FileViewState(_currentImage);
} 
