import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/Listing.dart';
import '../models/Review.dart';
import '../models/user.dart';

class ProfilePresenter{
  static final ProfilePresenter _profilePresenter = ProfilePresenter._internal();

  factory ProfilePresenter() {
    return _profilePresenter;
  }
  // singleton boilerplate
  ProfilePresenter._internal();

  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> retrieveUserProfile(String uid) async {
    DataSnapshot snapshot = await _databaseRef.child("users").child(uid).once();
    User user = new User(username: snapshot.value['username'],email: snapshot.value['email'],imagePath: snapshot.value['imagePath'], isAdmin: false);
    print(user);
    return user;
  }
  Future<void> updateUserProfile(User user) async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    uploadImage(File(user.imagePath));
    _databaseRef.child('Users').child(currentUser.uid).update({
      'username': user.username,
      'email': user.email,
      'isAdmin': false,

    });

    return;
  }
  Future<void> uploadImage(File image) async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    DataSnapshot snapshot = await _databaseRef.child("users").child(currentUser.uid).once();
    String pastUrl = await _storageRef.child("profileImages/" + snapshot.value['image']).getDownloadURL();
    StorageReference ref = await FirebaseStorage().getReferenceFromUrl(pastUrl);
    ref.delete();

    StorageReference firebaseStorageRef = _storageRef.child("profileImages/").child(currentUser.uid);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask.onComplete;

    return;
  }

  Future<dynamic> getImg(String imageType,String imageName) async {
    String url = await FirebaseStorage.instance.ref().child("$imageType/$imageName").getDownloadURL();
    print("url retrieve successfully $url");
    return url;
  }

  Future<List<Listing>> retrieveUserListing(String uid) async {
    List<Listing> userNormalListing = new List<Listing>();
    await _databaseRef.child("Listing").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['userID'] == uid){
          Listing normalListing = new Listing(listingID: snapshot.key,listingTitle: value['listingTitle'],category: value['category']
              ,postDateTime: DateTime.parse(value['postDateTime']),description: value['description'],isRequest: value['isRequest'],
              listingImage: value['listingImage'],longitude: value['longitude'],latitude:value['latitude'] );
          userNormalListing.add(normalListing);
        }
      });
    });

    return userNormalListing;
  }

  Future<List<Listing>> retrieveUserRequestListing(String uid) async {
    List<Listing> userRequestListing = new List<Listing>();
    await _databaseRef.child("Listing").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['isRequest']== true && value['userID'] == uid){
          Listing normalListing = new Listing(listingID: snapshot.key,listingTitle: value['listingTitle'],category: value['category']
              ,postDateTime: value['postDateTime'],description: value['description'],isRequest: value['isRequest'],
              listingImage: value['listingImage'],longitude: value['longitude'],latitude:value['latitude'] );
          userRequestListing.add(normalListing);
        }
      });
    });
    return userRequestListing;
  }

  Future<List<Review>> reviewList(String uid) async {
    List<Review> reviewList = new List<Review>();
    await _databaseRef.child("Review").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['revieweeID'] == uid){
          Review review = new Review(reviewID: snapshot.key,description: value['description'], listingID: value['listingID'],
          revieweeID: value['revieweeID'], reviewerID: value['reviewerID'],
              postedDateTime: DateTime.parse(value['postedDateTime']));
          print(review);
          reviewList.add(review);
        }
      });
    });
    return reviewList;
  }
  Future<List<User>> reviewerProfilePictures(String uid) async {
    List<User> reviewerDetails = new List<User>();
    await _databaseRef.child("Review").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        if(value['revieweeID'] == uid){
          _databaseRef.child("users").child(value['reviewerID']).once().then((DataSnapshot snapshot){
            User user = new User(username: snapshot.value['username'],email: snapshot.value['email'],imagePath: snapshot.value['imagePath'], isAdmin: false);
            reviewerDetails.add(user);
          });
        }
      });
    });
    return reviewerDetails;
  }
  int countDays (DateTime date){
    final currentDate = DateTime.now();
    int days = currentDate.difference(date).inDays;
    return days;
  }

}