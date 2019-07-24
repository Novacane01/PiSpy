// import 'package:pi_spy/main.dart';

import 'package:pi_spy/views/stream_view.dart';
import 'package:pi_spy/views/camera_view.dart';
import 'package:flutter/material.dart';

class HomeViewState extends State<HomeView>{
  int _currentIndex = 0;
  final List<Widget> _children = [StreamView(),Camera(),Container(color: Colors.green,)];

  @override
  Widget build(BuildContext context){
    print('Creating Scaffold');
    return Scaffold(
      appBar: AppBar(
        title: Text('PiSpy'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          setState(() {
          _currentIndex = index; 
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            title: Text('Livestream'),
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text('Camera'),
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             title: Text('Profile')
           )
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //       // Important: Remove any padding from the ListView.
      //       padding: EdgeInsets.zero,
      //       children: <Widget>[
      //         DrawerHeader(
      //           child: Text('Drawer Header'),
      //           decoration: BoxDecoration(
      //             color: secondaryColor,
      //           ),
      //         ),
      //         ListTile(
      //           title: Text('Home'),
      //           onTap: () {
      //             Navigator.pop(context);
      //             Navigator.pushReplacementNamed(context,'/Menu');
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Files'),
      //           onTap: () {
      //             Navigator.pop(context);
      //             Navigator.pushNamed(context,'/Files');
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Camera Options'),
      //           onTap: () {
      //             // Update the state of the app
      //             // ...
      //           },
      //         ),
      //       ],
      //     ),
      // ),
      body: _children[_currentIndex],
    );
  }
}

class HomeView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>HomeViewState();
}