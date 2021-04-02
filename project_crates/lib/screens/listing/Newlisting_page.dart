import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/databaseAccess.dart';
import 'package:flutter_application_1/backend/locationService.dart';
import 'package:flutter_application_1/backend/storageAccess.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import '../home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Newlisting_page extends StatelessWidget {
  String _search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFFC857),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(70.0))),
            title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment(-0.7, 0),
                      child: Column(children: <Widget>[
                        Text('New Listing',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ]))
                ])),
        body: Body());
    // body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //String isSelected;

  @override
  initState() {
    super.initState();
    getUID().then((uid) {
      setState(() {
        userid = uid;
      });
    });
  }

  String userid;
  List<bool> isselected = [true, false];
  List listItem = [
    'Vegetables',
    'Canned Food',
    'Dairy Product',
    'Snacks',
    'Beverages',
    'Dry Food'
  ];
  String valueChoose;
  File image;

  final listingTitleController = TextEditingController();
  final descriptionController = TextEditingController();

  LocationService loc = LocationService();
  DatabaseAccess dao = DatabaseAccess();
  StorageAccess storageAccess = StorageAccess();

  MapHandler _mapHandler = new MapHandler();
  Prediction _prediction;
  LatLng _currentLocation;
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //body: Center(
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          Align(
              alignment: Alignment(-0.7, 0),
              child: Text(
                  'I am...', // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  //color: Colors.grey,

                  child: Container(
                    color: Colors.grey[300],
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(10.0),
                      isSelected: isselected,
                      color: Colors.white,
                      selectedColor: Color(0xFFFFC857),
                      fillColor: Colors.grey,
                      renderBorder: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Giving away',
                              style: TextStyle(fontSize: 20)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Requesting for ',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                      onPressed: (int newIndex) {
                        setState(() {
                          for (int buttonIndex = 0;
                          buttonIndex < isselected.length;
                          buttonIndex++) {
                            if (buttonIndex == newIndex) {
                              isselected[buttonIndex] = true;
                            } else {
                              isselected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              ]),
          Align(
              alignment: Alignment(-0.8, 0),
              child: Text(
                  'a', // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: Text(
                    'Option',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  value: valueChoose,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue;
                    });
                  },
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                )),
          ),
          Align(
              alignment: Alignment(-0.7, 0),
              child: Text(
                  "it's called ...", // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              child: TextField(
                  style: TextStyle(fontSize: 10),
                  controller: listingTitleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Name of the product',
                  )),
            ),
          ),
          Align(
              alignment: Alignment(-0.5, 0),
              child: Text(
                  "Additional details", // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: TextField(
                    style: TextStyle(fontSize: 10),
                    controller: descriptionController,
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.fromLTRB(10, 40, 10, 40),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Description of the product')),
              ),
            ),
          ),
          Align(
              alignment: Alignment(-0.8, 0),
              child: Text(
                  "Address", // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold))),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: TextField(

                    style: TextStyle(fontSize: 10),
                    controller: addressController,
                    onTap: ()async{
                      _prediction = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: _mapHandler.LocationAPIkey,
                          mode: Mode.overlay, // Mode.fullscreen
                          language: "en");
                      LatLng _selected = await _mapHandler.getLatLng(_prediction);

                      setState(() {
                        _currentLocation = _selected;
                        addressController.text = _prediction.description;
                      });

                    },
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.fromLTRB(10, 30, 10, 30),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Address')),
              ),
            ),
          ),

          SizedBox(height: 20),
          InkWell(
            onTap: () async{
              _showPicker(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: image != null
                  ? Image.file(
                image,
                height: 200,
                width: 200,
              )
                  : Container(
                height: 200.0,
                width: 200.0,
                color: Colors.grey[300],
                child: Icon(Icons.photo_camera,
                    color: Colors.white, size: 50.0),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            //alignment: Alignment(0.7,0),
            child: MaterialButton(
              elevation: 1,
              minWidth: 100, // width of the button
              height: 50,
              onPressed: () async {
                if (listingTitleController.text == '') {
                  print('no listing title inputted');
                  return; //TODO frontend user warning for empty listingTitle/itemName
                }
                //TODO location and address optional?

                String imageString = image != null
                    ? await storageAccess.uploadFile(image)
                    : null;

                Listing newListing = Listing(
                  userID: userid,
                  listingTitle: listingTitleController.text,
                  longitude: _currentLocation.longitude,
                  latitude: _currentLocation.latitude,
                  category: valueChoose,
                  isRequest: isselected[1],
                  listingImage: imageString,
                  isComplete: false,
                  description: descriptionController.text,
                );

                await dao.addListing(newListing);
                //execute upadate
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => Home()));
                await Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
              },
              color: Color(0xFFFFC857),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),

              child: Text('Post',
                  style: TextStyle(color: Colors.grey[600], fontSize: 35)),
            ),
          ),

          //////////////////////////////////////////////////////////////////////////////////////
        ]),
      ),
    );
  }

  Future<String> getUID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _gallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _camera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  _camera() async {
    var _image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    if (_image == null) {
      print('No image taken.');
      return;
    }
    setState(() {
      image = _image;
    });
  }

  _gallery() async {
    var _image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    if (_image == null) {
      print('No image selected.');
      return;
    }
    setState(() {
      image = _image;
    });
  }
}
