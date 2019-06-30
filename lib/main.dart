import 'package:flutter/material.dart';
import 'package:pi_spy/files_view.dart';
import 'package:pi_spy/home_view.dart';
import 'package:pi_spy/register_view.dart';
import 'package:pi_spy/file.dart';


final primaryColor = Color(0xFFC41949);
final secondaryColor = Color(0xFF6bc048);

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
      ),
      initialRoute: '/',
      routes: {
        // '/': (context)=>RegisterView(),
        '/': (context)=>HomeView(),
        '/Files': (context)=>
        FutureBuilder(
          future: loadFiles(),
          builder: (context,snapshot){
            print(snapshot.hasData);
            if(snapshot.hasData){
              return FilesView();
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      },
    );
  }
}
