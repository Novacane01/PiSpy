import 'package:flutter/material.dart';
import 'globals.dart' show files;
import 'menu.dart';


final primaryColor = Color(0xFFC41949);
final secondaryColor = Color(0xFF6bc048);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    files = Map(); //COME BACK HERE AND TIDY UP
    print("Creating Material App");
    return MaterialApp(
      title: 'HSS',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: MenuView(),
    );
  }
}





class HomeView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Text('');
  }
}
