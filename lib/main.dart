import 'package:flutter/material.dart';
import 'package:pi_spy/views/files_view.dart';
import 'package:pi_spy/views/home_view.dart';
import 'package:pi_spy/views/register_view.dart';
import 'package:pi_spy/file.dart' as files;
import 'package:pi_spy/storage.dart' as storage;


final Color primaryColor = Color(0xFFC41949);
final Color secondaryColor = Color(0xFF6bc048);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Creating Material App");
    storage.init(); //Initalize storage location
    return MaterialApp(
      title: 'Pi-Spy',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: secondaryColor,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/',
      routes: {
        // '/': (context)=>RegisterView(),
        '/': (context)=>HomeView(),
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
