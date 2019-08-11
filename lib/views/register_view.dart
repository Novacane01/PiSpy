import 'package:flutter/material.dart';
import 'package:pi_spy/views/home_view.dart';
import 'package:pi_spy/main.dart' show secondaryColor , primaryColor;
import 'package:dbcrypt/dbcrypt.dart';

// import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewState extends State<RegisterView>{
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  double progress = 0.0;
  FocusNode _focus = FocusNode();
  final _accountFormKey = GlobalKey<FormState>();
  final _cameraFormKey = GlobalKey<FormState>();
  bool _canViewPassword = false;
  PageController _pageController;
  Map<String,String> formInfo = Map<String,String>();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _pageController = PageController();
  }

  void _onFocusChange(){
    setState(() {
      
    });
  }

  Widget _registerFormAccount(){
    return Form(
        key: _accountFormKey,
        child: Container(
          margin: EdgeInsets.only(left:20.0,right:20),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10.0,
            children: <Widget>[
              //Email
              TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Field can not be empty';
                  }
                  if(RegExp(r'\w+@(yahoo|aol|gmail|outlook)+.com').allMatches(value).isEmpty){
                    return 'Please enter a valid email address';
                  }
                },
                onSaved: (value)=>formInfo['email'] = value,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: secondaryColor),
                  labelText: 'E-mail:',
                  hintText: 'example123@gmail.com',
                  contentPadding: EdgeInsets.only(bottom:10.0),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                ),
              ),
              //Password
             TextFormField(
                  focusNode: _focus,
                  obscureText: (_canViewPassword)?false:true,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Field cannot be empty';
                    }
                  },
                  onSaved: (value)=>formInfo['password'] = value,
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
              //Password Confirm
              TextFormField(
                  obscureText: (_canViewPassword)?false:true,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Field cannot be empty';
                    }
                    if(value!=formInfo['password']){
                      return 'Passwords do not match';
                    }
                  },
                  onSaved: (value)=>formInfo['passwordConfirm'] = value,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: secondaryColor),                  
                    labelText: 'Confirm Password:',
                    hintText: 'example123',
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
                  ),
                ),
              // //Name
              // Container(
              //   child: TextFormField(
              //     validator: (value){
              //       if(value.isEmpty){
              //         return 'Field cannot be empty';
              //       }
              //     },
              //     onSaved: (value)=>formInfo['name'] = value,
              //     decoration: InputDecoration(
              //       labelStyle: TextStyle(color: secondaryColor),                  
              //       labelText: 'Name:',
              //       hintText: 'example',
              //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
              //     ),
              //   ),
              //   margin: EdgeInsets.only(left:20.0,right:20),
              //   padding: EdgeInsets.only(top: 10.0),
                
              // ),
              // //Phone Number
              // Container(
              //   child: TextFormField(
              //     validator: (value){
              //       if(value.isEmpty){
              //         return 'Field cannot be empty';
              //       }
              //     },
              //     decoration: InputDecoration(
              //       labelStyle: TextStyle(color: secondaryColor),                  
              //       labelText: 'Phone Number:',
              //       hintText: '123',
              //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
              //     ),
              //   ),
              //   margin: EdgeInsets.only(left:20.0,right:20),
              // ),
              // Padding(padding: EdgeInsets.only(top: 30.0),),
              RaisedButton(
                child: Text('Next'),
                onPressed: (){
                  _accountFormKey.currentState.save();
                  if(_accountFormKey.currentState.validate()){
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
                color: secondaryColor.withAlpha(150),
                elevation: 0.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
            ],
          ),
        ),
      );
  }
  void _completeRegistration(){
    
      // Navigator.pushReplacementNamed(context, '/Home');

  }
  
  Widget _registerFormCamera(){
    return Form(
      key: _cameraFormKey,
      child: Wrap(
        children: <Widget>[
          TextFormField(
            validator: (value){
              
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: secondaryColor),
              labelText: 'Camera MAC Address',
              hintText: '00:0a:95:9d:68:16',
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
            ),
          ),
          TextFormField(
            validator: (value){
              
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: secondaryColor),
              labelText: 'Camera IP Address',
              hintText: '0.0.0.0',
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor,width: 2.0)),
            ),
          ),
          RaisedButton(
            color: secondaryColor.withAlpha(150),
            onPressed:()=>_completeRegistration(),
            child: Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    print(progress);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'resources/images/pispy.png',
                  height: 125.0,
                  ),
                  padding: EdgeInsets.only(bottom:50.0)  
              ),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: primaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
              Padding(padding: EdgeInsets.all(20.0),),
              Container(
                height: 250.0,
                child: PageView(
                  controller: _pageController,
                  children: [
                    _registerFormAccount(),
                    _registerFormCamera()
                    ],
                  onPageChanged: (int pageNumber){
                    setState(() {
                      progress+=0.33;
                    });
                  },
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterView extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>RegisterViewState();
}