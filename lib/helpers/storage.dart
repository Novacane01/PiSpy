import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
Directory dir;

void init()async{
  // getExternalStorageDirectory()
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if(permission != PermissionStatus.granted){
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if(permissions[PermissionGroup.storage] == PermissionStatus.granted){
      getApplicationDocumentsDirectory().then((Directory directory)async{
        dir=directory; //Initialize path to local phone storage
        print(directory);
      });
    }
  }
}

void createFile(Object data,String fileName){
  print('Creating File!');
  File file = File(dir.path+'/'+fileName);
  if(!file.existsSync()){
    file.createSync(recursive: true);
    file.writeAsBytesSync(utf8.encode(data.toString()));
    print('File created');
  }
  else{
    print('File already exists!');
  }
}

Object readFile(String fileName){
  File file = File(dir.path+'/'+fileName);
  if(file.existsSync()){
    return json.decode(file.readAsStringSync());
  }
  else{
    print('File does not exist');
    return null;
  }
}

void deleteFile(String fileName){
  print('Deleting file');
  File file = File(dir.path+'/'+fileName);
  if(file.existsSync()){
    file.deleteSync();
  }
  else{
    print('File does not exist');
  }
}
