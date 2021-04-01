import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/Listing.dart';
import 'package:path/path.dart' as Path;
import '../models/user.dart';
import 'auth.dart';

class ProfilePresenter{
  static final ProfilePresenter _profilePresenter = ProfilePresenter._internal();

  factory ProfilePresenter() {
    return _profilePresenter;
  }
  // singleton boilerplate
  ProfilePresenter._internal();

  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var uuid = Uuid();

  Future<User> retrieveUserProfile(String uid) async {
    var snapshot = await _databaseRef.child('users').child(uid).once();
    var user = User(userID:snapshot.value['userID'],username: snapshot.value['username'],email: snapshot.value['email'],imagePath: snapshot.value['imagePath'], isAdmin: false);
    print(user.userID);
    return user;
  }
  Future<void> updateUserProfile(String username, String image) async {
    var user = await FirebaseAuth.instance.currentUser();
    await _databaseRef.child("users").child(user.uid).update({
      "username": username,
      "imagePath" : image
    });
    return;
  }
  Future<List<Listing>> retrieveUserListing(String uid) async {
    var userNormalListing = <Listing>[];
    await _databaseRef.child('Listing').once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['userID'] == uid && value['isRequest'] == false){
          var normalListing = Listing(listingID:key,listingTitle: value['listingTitle'],category: value['category']
              ,postDateTime: DateTime.parse(value['postDateTime']),description: value['description'],isRequest: value['isRequest'],isComplete: value['isComplete'],
              listingImage: value['listingImage'],longitude: value['longitude'],latitude:value['latitude'] );
          userNormalListing.add(normalListing);
        }
      });
    });

    return userNormalListing;
  }

  Future<List<Listing>> retrieveUserRequestListing(String uid) async {
    var userRequestListing = <Listing>[];
    await _databaseRef.child('Listing').once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['userID'] == uid && value['isRequest'] == true){
          var normalListing = Listing(listingID: key,listingTitle: value['listingTitle'],category: value['category']
              ,postDateTime: DateTime.parse(value['postDateTime']),description: value['description'],isRequest: value['isRequest'],isComplete: value['isComplete'],
              listingImage: value['listingImage'],longitude: value['longitude'],latitude:value['latitude'] );
          userRequestListing.add(normalListing);
        }
      });
    });
    return userRequestListing;
  }
  Future<String> uploadProfilePic(File file) async {
    String randomString = uuid.v4();
    var storageReference = _storageRef.ref().child('Profile/$randomString${Path.basename(file.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File uploaded');
    String url = await storageReference.getDownloadURL();
    return url;
  }
  Future<void> deleteCurrentProfilePic(String url) async {
    if (url == null) return;
    StorageReference storageRef = await _storageRef.getReferenceFromUrl(url);
    await storageRef.delete();
    print("Storage Image deleted");
  }
  void changePassword(String emailAddr,String newPassword) async{
    //Create an instance of the current user.
    var user = await FirebaseAuth.instance.currentUser();
    //Pass in the password to updatePassword.
    await user.updatePassword(newPassword).then((_){
      print('Successfully changed password');
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });

  }
  Future<bool> getCurrentPassword(String emailAddr, String oldPassword) async{
    bool correctPass = false;
    var credential = EmailAuthProvider.getCredential(email: emailAddr, password: oldPassword);
    if(credential != null){
      correctPass = true;
    }
    print(correctPass);
    return correctPass;
  }


}