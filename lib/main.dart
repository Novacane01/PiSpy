import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pi_spy/views/files_view.dart';
import 'package:pi_spy/views/home_view.dart';
import 'package:pi_spy/views/register_view.dart';
import 'package:pi_spy/helpers/file.dart' as files;
import 'package:pi_spy/helpers/storage.dart' as storage;

final Color primaryColor = Color(0xFFC41949);
final Color secondaryColor = Color(0xFF6bc048);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  _initializeNotifications(){
    _firebaseMessaging.subscribeToTopic('motion_detected');
    _firebaseMessaging.getToken().then((value){
      _token=value;
      print(_token);
    });
    _firebaseMessaging.configure(
      onLaunch: (Map<String,dynamic> message){
        print('onLaunch: $message');
        return Future.value('');
      },
      onMessage: (Map<String,dynamic> message){
        print('onMessage: $message');
        return Future.value('');
      },
      onResume: (Map<String,dynamic> message){
        print('onResume: $message');
        return Future.value('');
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    print("Creating Material App");
    _initializeNotifications();
    // storage.init(); //Initalize storage location
    return MaterialApp(
      title: 'Pi-Spy',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: secondaryColor,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/',
      routes: {
        '/': (context)=>RegisterView(),
        '/Home': (context)=>HomeView(),
        '/Files': (context)=>
        FutureBuilder(
          future: files.loadFiles(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return FilesView();
            }
            else if(snapshot.hasError){
              return Container(
                color: Colors.white,
                child:Center(
                  child: Text('There was an error connecting to the camera.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12 ,
                      decoration: TextDecoration.none,
                      fontFamily: 'Montserrat'
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              );
            }
            else{
              return Container(
                color: Colors.white,
                child: Column(children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 10,bottom: 10),),
                  Text('Gathering Files...Please be patient.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12 ,
                      decoration: TextDecoration.none,
                      fontFamily: 'Montserrat'
                      ),
                    ),
                  ],
                mainAxisAlignment: MainAxisAlignment.center,),
              );
            }
          },
        ),
      },
    );
  }
}
