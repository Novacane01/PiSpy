import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CameraState extends State<Camera>{
  bool _isCameraEnabled = false;

  @override
  void initState(){
    super.initState();
    getCameraStatus().then((res){
      print(res.body);
      setState(() {
        _isCameraEnabled = res.body == 'true';
      });
    });
  }

  Future<http.Response> getCameraStatus(){
  return http.get('http://192.168.0.26:7070/status');
}
  @override
  Widget build(BuildContext context){
    print('Creating ListView');
    return camMenu(context);
  }
  Future<http.Response> _updateCameraStatus(){
    return http.post('http://192.168.0.26:7070/camera/${_isCameraEnabled ? 'enable':'disable'}');
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
            Navigator.pushNamed(context, '/Files');
          },
        ),
        Divider(height: 4.0,),
      ],
    );
  }
}

class Camera extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>CameraState();
}
