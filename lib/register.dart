import 'package:flutter/material.dart';
import 'home.dart';
import 'main.dart' show secondaryColor;

class RegisterViewState extends State<RegisterView>{
  FocusNode _focus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _canViewPassword = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    setState(() {
      
    });
  }

  void _register1(){
    if(_formKey.currentState.validate()){
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (context){
          return HomeView();
        }
      ));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Image.asset(
                'resources/pispy.png',
                height: 100.0,
                ),  
              padding: EdgeInsets.only(top: 25.0),
            ),
            LinearProgressIndicator(
              value: 0.3,
              ),
            //Email
            Container(
              child: TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Field can not be empty';
                  }
                  if(RegExp(r'\w+@\w+.com').allMatches(value).isEmpty){
                    return 'Please enter a valid email address';
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: secondaryColor),
                  labelText: 'E-mail:',
                  hintText: 'example123@gmail.com',
                  contentPadding: EdgeInsets.only(bottom:10.0),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                ),
              ),
              margin: EdgeInsets.only(left:20.0,right:20),
              padding: EdgeInsets.only(top: 10.0),
            ),
            //Password
            Container(
              child: TextFormField(
                focusNode: _focus,
                obscureText: (_canViewPassword)?false:true,
                validator: (value){
                  if(value.isEmpty){
                    return 'Field cannot be empty';
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: secondaryColor),                  
                  labelText: 'Password:',
                  hintText: 'example123',
                  suffixIcon: (_focus.hasFocus)?IconButton(
                      icon: Icon((_canViewPassword) ? Icons.visibility_off: Icons.visibility,),
                      color: secondaryColor,
                      onPressed: () {
                        setState(() {
                          _canViewPassword = !_canViewPassword; 
                        });
                      },
                      padding: EdgeInsets.all(0.0),
                    ):null,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                ),
              ),
              margin: EdgeInsets.only(left:20.0,right:20),
              padding: EdgeInsets.only(top: 10.0),
            ),
            //Name
            Container(
              child: TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Field cannot be empty';
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: secondaryColor),                  
                  labelText: 'Name:',
                  hintText: 'example',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                ),
              ),
              margin: EdgeInsets.only(left:20.0,right:20),
              padding: EdgeInsets.only(top: 10.0),
              
            ),
            //Phone Number
            Container(
              child: TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Field cannot be empty';
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: secondaryColor),                  
                  labelText: 'Phone Number:',
                  hintText: '123',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                ),
              ),
              margin: EdgeInsets.only(left:20.0,right:20),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),),
            Container(
              child: RaisedButton(
                child: Text('Next'),
                onPressed: ()=>_register1(),
                color: secondaryColor.withAlpha(150),
                elevation: 0.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              padding: EdgeInsets.only(left:100.0,right: 100.0),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>RegisterViewState();
}