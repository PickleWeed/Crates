import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/widgets.dart';
import 'file:///D:/GitHub%20Repositories/CZ3003_Crates/project_crates/lib/screens/common/theme.dart';

// Contains all three widget trees for the registration process
// Register, RegisterNext and RegisterFinal

// First screen
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                            "Create\nan account",
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
                                hintText: 'email')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnText: 'Next',
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
                            btnText: 'Sign In',
                            btnPressed: (){}
                        ),
                        SizedBox(height: 120),
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

// Second screen
class RegisterNext extends StatefulWidget {
  @override
  _RegisterNextState createState() => _RegisterNextState();
}

class _RegisterNextState extends State<RegisterNext> {
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
                        SizedBox(height: 80),
                        Center(
                          child: Text(
                            "Create\nan account",
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
                                hintText: 'email')),
                        SizedBox(height: 10),
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'username')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnText: 'Next',
                            btnPressed: (){}
                        ),
                        SizedBox(height: 160),
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

// Final screen
class RegisterFinal extends StatefulWidget {
  @override
  _RegisterFinalState createState() => _RegisterFinalState();
}

class _RegisterFinalState extends State<RegisterFinal> {
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
                            "Create\nan account",
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
                                hintText: 'email')),
                        SizedBox(height: 10),
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'username')),
                        SizedBox(height: 10),
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'password')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnText: 'Register',
                            btnPressed: (){}
                        ),
                        SizedBox(height: 120),
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

