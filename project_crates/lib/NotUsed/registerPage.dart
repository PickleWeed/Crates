import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange,
            title: Text(
              "Register User",
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(70.0)))),
        body: Body());
    // body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Widget usernameField() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter Username',
          hintText: 'username'),
    );
  }

  Widget passwordField() {
    return TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Password',
            hintText: 'Password'));
  }

//TODO submit button to database
  Widget submitButton() {
    return ButtonTheme(
        minWidth: 300.0,
        height: 60.0,
        child: FlatButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Submit',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 80.0),
        ),
        Container(
            width: 400,
            height: 100,
            alignment: Alignment.center,
            child: Text('Register Account',
                style: TextStyle(color: Colors.amber, fontSize: 40))),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: usernameField(),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: passwordField(),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: submitButton(),
        ),
      ],
    )));
  }
}
