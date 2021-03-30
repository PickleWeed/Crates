// Dummy page to test database functionalities
// To view this dummy page, replace the 'home' property value in main.dart to CreateListingTest()
// Change the onPressed method in the ElevatedButton widget to test different methods
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/databaseAccess.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/services/locationService.dart';
import 'package:flutter_application_1/services/storageAccess.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateListingTest extends StatefulWidget {
  @override
  _CreateListingTestState createState() => _CreateListingTestState();
}

class _CreateListingTestState extends State<CreateListingTest> {
  @override
  DatabaseAccess dao = new DatabaseAccess();
  LocationService loc = new LocationService();
  List<bool> isSelected = [true, false];
  String _selectedCategory;
  List<String> _categories = ['Canned Food', 'Vegetables', 'Raw Meat'];
  final itemNameController = TextEditingController();
  final descController = TextEditingController();
  File image;
  List<String> imageURL = [];
  final imagePicker = ImagePicker();
  StorageAccess storageAccess = new StorageAccess();
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Listing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.grey,
              borderWidth: 2,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Requesting for',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Giving away',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
              isSelected: isSelected,
            ),
            DropdownButton(
              hint: Text('Select category'),
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name',
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
                child: Text(
                    "Sign in anonymously"), //NEED TO SIGN IN FIRST FOR EVERYTHING TO WORK
                onPressed: () async {
                  dynamic user = await signInAnon();
                  uid = user.uid;
                  print(uid);
                }),
            ElevatedButton(
              child: Text("Select image/s"),
              onPressed: chooseFile,
            ),
            ElevatedButton(
                child: Text("Test function"),
                onPressed: () async {
                  // List location = await loc.getLatLong();

                  //Modify the postDateTime and userID attribute values below, the rest are read from the user interface
                  // Listing listing = new Listing(
                  //     isRequest: isSelected[0],
                  //     category: _selectedCategory,
                  //     listingTitle: itemNameController.text,
                  //     description: descController.text,
                  //     latitude: location[0],
                  //     longitude: location[1],
                  //     listingImage: image,
                  //     userID: uid,
                  //     postDateTime:
                  //         DateTime.parse("2021-03-15T08:26:25.276101"));

                  // dao.addListing(listing);

                  dao.deleteListingOnKey("-MWmtJHYl4N3FbYTdl3G");

                  // dao.updateListing("-MVozP1mmCHPKI1JfPlG", listing);

                  // List listingList = await dao.retrieveAllListings();
                  // for (int i = 0; i < listingList.length; i++) {
                  //   print(listingList[i].listingTitle);
                  // }
                }),
          ],
        ),
      ),
    );
  }

  Future chooseFile() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('No image selected.');
      return;
    }
    setState(() {
      image = File(pickedFile.path);
    });
  }

  //Temporary sign in function
  Future signInAnon() async {
    try {
      AuthResult result = await auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print('Error signing in');
    }
  }
}
