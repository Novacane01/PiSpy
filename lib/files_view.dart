import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pi_spy/main.dart';
import 'package:video_player/video_player.dart';
import 'package:pi_spy/file.dart';

//VIEWING ALL FILES
enum FileMode{
  VIEW, SELECT
}

class FilesViewState extends State<FilesView>{
  FileMode fileMode = FileMode.VIEW;
  String content = 'image';
  Set<File> _selectedFiles = Set<File>();

  //Pushes individual file view to stack
  void _showFile(File file){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context){
        return FileView(file);
      },
    ),);
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
              items: ['Images', 'Videos'].map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value){
                print(value);
                setState(() {
                if(value=='Images'){
                  content = 'image';
                }
                else if(value=='Videos'){
                  content = 'video';
                }
                });
              },
            ),
          ),
          if (fileMode == FileMode.SELECT) IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              print('Files want to be deleted');
              setState(() {
                for(File file in _selectedFiles){
                  deleteFile(file);
                }
              });
            },
          )
        ],
      ),
      //ListView of files separated by dividers
      body: ListView.builder(
        itemCount: (files[content]!=null)?files[content].length*2 + 1:0,
        itemBuilder: (context, index){
          if(index%2==1){
            File _currentFile = files[content].values.toList()[index~/2];
            bool _selected = _selectedFiles.contains(_currentFile);
            return Ink(
              color: _selected ? secondaryColor : Colors.white,
              child: ListTile( //TODO: Come back and clean up maybe
                title: Text(_currentFile.name),
                leading: _selected ? Icon(Icons.check_circle) : null,
                trailing:(content=='image')?
                  ClipRRect(borderRadius: BorderRadius.circular(5.0),child:(_currentFile as Img).img):
                  Container(child:ClipRRect(borderRadius: BorderRadius.circular(5.0),child:VideoPlayer((_currentFile as Vid).vid,)),width: 100.0,),
                onTap: (){
                  if(fileMode == FileMode.VIEW){ //Open individual file view
                    _showFile(files[content].values.toList()[index~/2]);
                  }
                  else{ //Select/Deselect file
                    setState(() { 
                      if(_selected){
                        _selectedFiles.remove(_currentFile);
                      }
                      else{
                        _selectedFiles.add(_currentFile);
                      }
                      if(_selectedFiles.isEmpty){
                        fileMode = FileMode.VIEW;
                      }
                    });
                  }
                },
                onLongPress: (){
                  setState(() {
                    fileMode = FileMode.SELECT;
                    print(_currentFile.name);
                   _selectedFiles.add(_currentFile);
                   print(_selectedFiles);
                  });
                },
              )
            );
          }
          else if(files[content].length>0){
            return Divider(height: 5.0,); //Retrurn a divider after every file entry
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
                      deleteFile(_currentFile);
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
