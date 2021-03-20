import 'package:flutter/material.dart';
import '../common/widgets.dart';
import '../common/theme.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            "Sign in to\nyour account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 1,
                              color: offWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'username')),
                        SizedBox(height: 5),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'password')),
                        SizedBox(height: 20),
                        CustomButton(
                            btnText: 'Log In',
                            btnPressed: (){}
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,10,20,10),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Divider(color:offWhite, thickness:2)
                                ),
                                SizedBox(width: 10,),
                                Text("OR",
                                    style: TextStyle(
                                      color:offWhite,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(width: 10,),
                                Expanded(
                                    child: Divider(color:offWhite, thickness:2)
                                ),
                              ]
                          ),
                        ),
                        CustomButton(
                            btnText: 'Register',
                            btnPressed: (){}
                        ),
                        SizedBox(height: 100),
                        Text('CRATES',
                          style: TextStyle(
                            letterSpacing: 3,
                            color: offWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),),
                        Text('By Team Gestalt',
                          style: TextStyle(
                            color: offWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                      ]),
                ))));
  }
}