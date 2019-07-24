import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pi_spy/file.dart';

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
    }).catchError((error){
      _isCameraEnabled = false;
      print(error);
    });
  }

  @override
  Widget build(BuildContext context){
    print('Creating ListView');
    return camMenu(context);
  }
  Future<http.Response> _updateCameraStatus(newValue) async{
    try{
      setState(() {
        _isCameraEnabled = newValue;
      });
      http.Response res = await http.post('http://24.250.172.18:6890/camera/${newValue ? 'enable':'disable'}');
      return res;
    }catch(e){
      setState(() {
        _isCameraEnabled = !newValue;
      });
      return Future.error(e);
    }
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
              _updateCameraStatus(newValue);
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
