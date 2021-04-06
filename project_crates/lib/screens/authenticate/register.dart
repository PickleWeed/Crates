import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/models/user.dart';
import '../authenticate/sign_in.dart';
import '../authenticate/root.dart';
import '../common/widgets.dart';
import '../common/theme.dart';

// Contains all three widget trees for the registration process
// Register, RegisterNext and RegisterFinal
@override

// First screen
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey = new GlobalKey<FormState>();
  final emailController = TextEditingController();

  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool validateEmail() {
    final form = formKey.currentState;
    if(form.validate()){
      print("Email is valid");
      return true;
    }else{
      print("Email is not valid");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
                key: formKey,
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
                            key: const Key('email'),
                            validator: (value)=> value.isEmpty ? "Email Required" : !value.contains("@") ? "Invalid Email" : null,
                            controller: emailController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Email')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnKey: 'Next',
                            btnText: 'Next',
                            btnPressed: () {
                              //Email Validation
                              if (validateEmail()) {
                                // Navigate to second register page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        RegisterNext(emailController.text)));
                              }
                            }
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
                            btnKey: 'SignIn',
                            btnText: 'Sign In',
                            btnPressed: (){
                              //Navigate to Sign In Page
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => RootPage()));
                            }
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

  // Get email input from previous screen and auto fill email input
  final String email;
  RegisterNext(this.email);

  @override
  _RegisterNextState createState() => _RegisterNextState();
}

class _RegisterNextState extends State<RegisterNext> {

  var userEmail;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userEmail = widget.email;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool validateUsername() {
    final form = formKey.currentState;
    if(form.validate()){
      print("Username is valid");
      return true;
    }else{
      print("Username is not valid");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
                key: formKey,
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
                            enabled: false,
                            controller: emailController..text = userEmail,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Email')),
                        SizedBox(height: 10),
                        TextFormField(
                            key: const Key('username'),
                            validator: (value)=> value.isEmpty ? "Username Required" : value.length < 3 ? "Username must be at least 3 characters" : null,
                            controller: usernameController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Username')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnKey: 'Next2',
                            btnText: 'Next',
                            btnPressed: () {
                              // Username validation
                              if (validateUsername()) {
                                // Navigate to last registration page
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => RegisterFinal(
                                        emailController.text,
                                        usernameController.text)));
                              }
                            }
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

  // Get email & username input from previous screen and auto fill inputs
  final String email;
  final String username;
  RegisterFinal(this.email, this.username);

  @override
  _RegisterFinalState createState() => _RegisterFinalState();
}

class _RegisterFinalState extends State<RegisterFinal> {

  var email;
  var username;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    email = widget.email;
    username = widget.username;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validatePassword() {
    final form = formKey.currentState;
    if(form.validate()){
      print("Password is valid");
      return true;
    }else{
      print("Password is not valid");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
                key: formKey,
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
                            enabled: false,
                            controller: emailController..text = email,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Email')),
                        SizedBox(height: 10),
                        TextFormField(
                            enabled: false,
                            controller: usernameController..text = username,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Username')),
                        SizedBox(height: 10),
                        TextFormField(
                            key: Key('password'),
                            validator: (value)=> value.isEmpty ? "Password Required" : value.length < 6 ? "Password must have at least 6 characters" : null,
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: offWhite,
                                hintText: 'Password')),
                        SizedBox(height: 10),
                        CustomButton(
                            btnKey: 'Register',
                            btnText: 'Register',
                            btnPressed: () async {
                              // Password Validation
                              if (validatePassword()) {
                                // Register User
                                FirebaseUser user = await createUserWithEmailAndPassword(emailController.text, passwordController.text, context);
                                await createUserDetails(user, usernameController.text, emailController.text);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RootPage()));
                              }
                            }
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

