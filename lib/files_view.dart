import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:pi_spy/file.dart';

//VIEWING ALL FILES

class FilesViewState extends State<FilesView>{
  String content = 'images';

  //Pushes individual file view to stack
  void _showFile(File file){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context){
        return FileView(file);
      },
    ),);
  }

  //Destroys video controllers when popping off context so they can be used again later
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
        actions: <Widget>[ //Dropdown menu to filter between images and videos
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
      //ListView of files separated by dividers
      body: ListView.builder(
        itemCount: (files[content]!=null)?files[content].length*2 + 1:0,
        itemBuilder: (context, index){
          if(index%2==1){
            return ListTile(
              title: Text(files[content][index~/2].name),
              trailing:(content=='images')?(files[content][index~/2] as Img).img:Container(child:VideoPlayer((files[content][index~/2] as Vid).vid,),width: 100.0,),
              onTap: (){
                _showFile(files[content][index~/2]);
              },
            );
          }
          else if(files[content].length>0){
            return Divider(); //Retrurn a divider after every file entry
          }
          else{
            return Center(
              child: Text('No files have been saved by your camera'), //Display message if no files have been saved yet
            );
          }
        },
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


//VIEWING INDIVIDUAL FILES

class FileViewState extends State<FileView>{
  VideoPlayerController _controller;
  final File _currentFile;
  FileViewState(this._currentFile);
  bool _isFinished = false;
  @override
  void initState() {
    print(_currentFile);
    if(_currentFile.type=='video'){
      _controller = (_currentFile as Vid).vid
      ..addListener((){
        final Duration position = _controller.value.position;
        if(position >= _controller.value.duration && !_isFinished){
          setState((){
            _isFinished = true;
          });
        }
        else if(_isFinished){
          _isFinished = false;
        }
      });
    }
    super.initState();
  }
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
            actions: <Widget>[ //Dropdown button to delete or save video to device
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: ['Delete', 'Save'].map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value){
                    if(value=='Delete'){
                      Navigator.pop(context); //TODO: Need to delete file from Pi
                    }
                  },
                ),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (_currentFile.type=='image')?(_currentFile as Img).img: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller)),
              ListTile(
                title: Text('Name: '),
              ),
              ListTile(
                title: Text('Date: '),
              ),
            ],
          ),
          floatingActionButton: (_currentFile.type=='video')?FloatingActionButton(
            onPressed: (){
              setState(() {
               (_controller.value.isPlaying) ? _controller.pause() :(_isFinished) ? _controller.initialize().then((val)=>_controller.play()): _controller.play(); //If the video has played all the wat through re-initialize it otherwise resume play if its pause and pause if its playing
              });
            },
            child: Icon(
              (_controller.value.isPlaying)? Icons.pause:Icons.play_arrow,
            ),
          ):null,
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
