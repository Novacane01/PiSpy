import 'camera.dart';
import 'package:flutter/material.dart';

class MenuView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    print('Creating Scaffold');
    return Scaffold(
      appBar: AppBar(
        title: Text('HSS'),
      ),
      body: Column(
        children: <Widget>[
          EnableCamera(),
        ],
      ),
    );
  }
}