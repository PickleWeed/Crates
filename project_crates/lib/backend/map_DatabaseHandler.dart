import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_application_1/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/Listing.dart';

class DataHandler {
  static final DataHandler _dataHandler = DataHandler._internal();

  factory DataHandler() {
    return _dataHandler;
  }
  // singleton boilerplate
  DataHandler._internal();

  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();
  //insert current location as argument
  Future<List<Listing>> retrieveFilteredListing(double distance, String category, LatLng center) async {
    List<Listing> userNormalListing = new List<Listing>();
    try {
      await _databaseRef.child("Listing").once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((key, value) {

          double calculatedDistance = 0;
          calculatedDistance = haversine(
              center.latitude, center.longitude, value['latitude'],
              value['longitude']);
          print('calculated: $calculatedDistance');
          if (value['isRequest'] == false && value['isComplete'] == false && calculatedDistance <= distance &&
              (category == value['category'] || category == '')) {
            //url = getImg("normalListings", snapshot.key).toString();
            Listing normalListing = new Listing(listingID: snapshot.key,
                userID : value['userID'],
                listingTitle: value['listingTitle'],
                category: value['category'],
                postDateTime: DateTime.parse(value['postDateTime']),
                description: value['description'],
                isRequest: value['isRequest'],
                isComplete: value['isComplete'],
                listingImage: value['listingImage'],
                longitude: value['longitude'],
                latitude: value['latitude']);
            userNormalListing.add(normalListing);
            print(userNormalListing.length);
          }
        });
      });
    } catch (e){
      print(e);
    }
    return userNormalListing;
  }
  //TODO for testing, almost never use
  Future<List<Listing>> retrieveAllListing() async {
    print('retrieveAllListing!');
    List<Listing> userNormalListing = new List<Listing>();
    String url = "";
    try {
      await _databaseRef.child("Listing").once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((key, value) {
          if (value['isRequest'] == false && value['isComplete'] == false) {
            Listing normalListing = new Listing(listingID: snapshot.key,
                listingTitle: value['listingTitle'],
                category: value['category'],
                postDateTime: DateTime.parse(value['postDateTime']),
                description: value['description'],
                isRequest: value['isRequest'],
                isComplete: value['isComplete'],
                listingImage: value['listingImage'],
                longitude: value['longitude'],
                latitude: value['latitude']);
            userNormalListing.add(normalListing);
          }
        });
      });
    } catch(e) {
      print(e);
    }
    return userNormalListing;
  }
  //return distance
  double haversine(double lat1, double lon1, double lat2, double lon2){
    if(lat1 == null || lat2 == null || lon1 == null || lon2 == null) {
      print('List Error! Null value - GPS position: $lat1, $lon1, listing position: $lat2, $lon2.');
      return null;
    }
    else{
      final R = 6372.8; // In kilometers

      double dLat = radians(lat2 - lat1);
      double dLon = radians(lon2 - lon1);
      lat1 = radians(lat1);
      lat2 = radians(lat2);
      double a = pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
      double c = 2 * asin(sqrt(a));
      return R * c;
    }
  }


  Future<List<String>> getUsernameList(List<Listing> list) async{
    List<String> usernameList = new List<String>();
    list.forEach((element) {
      _databaseRef.child("users").child(element.userID).once().then((DataSnapshot snapshot) {
        usernameList.add(snapshot.value['username']);
      });
    });
    return usernameList;
  }

}
