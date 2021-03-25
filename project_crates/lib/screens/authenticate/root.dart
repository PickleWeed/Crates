import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'sign_in.dart';
import '../home/home.dart';

class RootPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}
enum AuthStatus {
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{

  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  // Configure initial state before widget build
  void initState(){
    super.initState();
    currentUser().then((userID)=>{
      setState((){
        // authStatus = userID == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      })
    });
  }

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return new SignIn(
          onSignedIn: _signedIn ,
        );
      case AuthStatus.signedIn:
        return new Container(
          child: Home(
            // onSignedOut: _signedOut,
          ),
        );
    }
  }
}