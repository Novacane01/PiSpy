import 'package:flutter/material.dart';
import 'package:pi_spy/files_view.dart';
import 'package:pi_spy/home_view.dart';
import 'package:pi_spy/register_view.dart';
import 'package:pi_spy/file.dart';


final Color primaryColor = Color(0xFFC41949);
final Color secondaryColor = Color(0xFF6bc048);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    files = Map(); //TODO: COME BACK HERE AND TIDY UP
    print("Creating Material App");
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
          future: loadFiles(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return FilesView();
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
