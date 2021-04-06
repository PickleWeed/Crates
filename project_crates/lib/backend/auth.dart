import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/authenticate/root.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;

final FirebaseAuth _auth = FirebaseAuth.instance;
var _firebaseRef = FirebaseDatabase().reference().child('users');
FirebaseStorage storage = FirebaseStorage.instance;
var uuid = Uuid();
// Display Login Successful/Unsuccessful
displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}

// For Register Page
Future<FirebaseUser> createUserWithEmailAndPassword(email, password, context) async {
  final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: password,)).user;
  if (user!=null){
    print('Registered: ${user.uid}');
    displayToastMessage("Account Created Successfully", context);
  }
  return user;
}

void createUserDetails(userDB, username, email) async{
  FirebaseUser user = userDB;
  var file = await imageToFile();
  var url = await uploadProfilePic(file);


  _firebaseRef.child(user.uid).set({
    'userID':  user.uid, //Get from authentication db
    'username': username,
    'email': email,
    'isAdmin': false, //default false,
    'isBanned': '0', //default false
    'imagePath': url//default path
  });
}
 Future<File> imageToFile() async {
  var bytes = await rootBundle.load('assets/icons/default.png');
  String tempPath = (await getTemporaryDirectory()).path;
  File file = File('$tempPath/default.png');
  await file.writeAsBytes(
  bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  return file;
}
Future<String> uploadProfilePic(File file) async {
  String randomString = uuid.v4();
  var storageReference = storage.ref().child('Profile/$randomString${Path.basename(file.path)}');
  StorageUploadTask uploadTask = storageReference.putFile(file);
  await uploadTask.onComplete;
  print('File uploaded');
  String url = await storageReference.getDownloadURL();
  return url;
}

// For Sign In Page
Future<FirebaseUser> signInWithEmailAndPassword(email, password) async {
  try {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password,)).user;
    print('Signed in: ${user.uid}');

    return user;
  }
  catch(e){
    print('Error: $e');
    return null;
  }
}

Future<bool> isAdminCheck(userID) async{
  DataSnapshot snapshot =  await _firebaseRef.child(userID).once();
  return snapshot.value['isAdmin'];
}

Future<String> isBannedCheck(userID) async{
  DataSnapshot snapshot =  await _firebaseRef.child(userID).once();
  return snapshot.value['isBanned'];
}

// Get Current Login UserID
Future<String> currentUser() async {
  try{
    FirebaseUser user = await _auth.currentUser();
  return user.uid;
  } catch(e){
    print(e);
  }
  
}

//For Sign Out Button
Future<void> signOut(context) async {
  await _auth.signOut();
  displayToastMessage('Logout Successful', context);
  await Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => RootPage())
  );
}
