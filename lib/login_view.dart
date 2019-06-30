import 'package:flutter/material.dart';

class LoginViewState extends State<LoginView>{
  final primaryColor = Color(0xFFC41949);
  final secondaryColor = Color(0xFF6bc048);

  void _login(){
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (context){
        return Text('');
      }
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xc41949),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text('Pi Spy',style: TextStyle(fontSize: 36.0),),
            padding: EdgeInsets.only(top: 75.0,bottom: 75.0),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Username:',
                hintText: 'example123',
              ),
            ),
            margin: EdgeInsets.only(left:20.0,right:20),
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password:',
                hintText: 'example123',
              ),
            ),
            margin: EdgeInsets.only(left:20.0,right:20),
          ),
          Padding(padding: EdgeInsets.only(top: 30.0),),
          FlatButton(
            child: Text('Login'),
            onPressed: ()=>_login(),
            color: secondaryColor.withAlpha(150),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class LoginView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>LoginViewState();
}