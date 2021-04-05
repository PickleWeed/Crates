import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/databaseAccess.dart';
import 'package:flutter_application_1/backend/storageAccess.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/screens/common/error_popup_widgets.dart';
// import '../home/home.dart';

class Editinglist_page extends StatelessWidget {
  String _search;
  String listingID;
  Map arguments = {};

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    listingID = arguments["listingID"];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Column(children: <Widget>[
                  Text('Edit Listing',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ]))
              ]),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Body(
          listingID: listingID,
        ));
    // body: Body());
  }
}

class Body extends StatefulWidget {
  final String listingID;

  Body({
    @required this.listingID,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  initState() {
    super.initState();
    dao.getListing(widget.listingID).then((selectedListing) {
      setState(() {
        listing = selectedListing;
        listingTitleController.text = listing.listingTitle;
        descriptionController.text = listing.description;
        valueChoose = listing.category;
        imageURL = listing.listingImage;
        listingVenue = LatLng(listing.latitude, listing.longitude);
        isselected[1] = listing.isRequest;
        isselected[0] = !listing.isRequest;
        uid = listing.userID;
        imageCache.clear();
        storageAccess.fileFromImageUrl(imageURL).then((file) {
          setState(() {
            image = file;
          });
        });
      });
      loadVenueName();
    });
  }

  //String isSelected;
  List<bool> isselected = [true, false];
  List listItem = [
    'Beverages',
    'Canned Food',
    'Dairy Product',
    'Dry Food',
    'Snacks',
    'Vegetables',
  ];
  String valueChoose;
  File image;
  LatLng listingVenue;
  String imageURL;
  String uid;
  String venueName;

  loadVenueName() async {
    venueName = await _mapHandler.getAddressFromLatLng(
        listingVenue.latitude, listingVenue.longitude);
    if (this.mounted)
      setState(() {
        addressController.text = venueName;
      });
  }

  final listingTitleController = TextEditingController();
  final descriptionController = TextEditingController();

  DatabaseAccess dao = DatabaseAccess();
  StorageAccess storageAccess = StorageAccess();
  MapHandler _mapHandler = new MapHandler();
  Prediction _prediction;
  LatLng _newLocation;
  var addressController = TextEditingController();

  Listing listing;
  Map passedData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      //body: Center(
      child: Container(
        color: offWhite,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              _showPicker(context);
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: image != null
                    ? Image.file(image, height: 200.0, width: 200.0)
                    : Container(
                        height: 200.0,
                        width: 200.0,
                        color: Colors.grey[300],
                        child: Icon(Icons.photo_camera,
                            color: Colors.white, size: 50.0),
                      ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('I am ...',
                // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Container(
              height: 40,
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(8.0),
                isSelected: isselected,
                color: Colors.grey[500],
                selectedColor: primaryColor,
                fillColor: Colors.grey[800],
                renderBorder: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Giving away', style: TextStyle(fontSize: 17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text('Requesting for ', style: TextStyle(fontSize: 17)),
                  ),
                ],
                onPressed: (int newIndex) {
                  setState(() {
                    for (var buttonIndex = 0;
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('a ...',
                // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  focusColor: Colors.red,
                  value: valueChoose,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue;
                    });
                  },
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Text("it's called ...",
                // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              height: 50,
              child: TextField(
                  style: TextStyle(fontSize: 16),
                  controller: listingTitleController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'name of the item')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Text('description ...',
                // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: TextField(
                    minLines: 4,
                    //Normal textInputField will be displayed
                    maxLines: 4,
                    style: TextStyle(fontSize: 16),
                    controller: descriptionController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'description of the item')),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Text('location',
                // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: TextField(
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () async {
                      var prediction = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: _mapHandler.LocationAPIkey,
                          mode: Mode.overlay, // Mode.fullscreen
                          language: "en");
                      if (prediction != null) {
                        var _selected = await _mapHandler.getLatLng(prediction);
                        setState(() {
                          _newLocation = _selected;
                          addressController.text = prediction.description;
                          _prediction = prediction;
                        });
                      }
                    },
                    controller: addressController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'pick a location')),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.fromLTRB(100, 5, 100, 20),
            child: CustomCurvedButton(
                btnText: 'Save Changes',
                btnPressed: () async {
                  if (listingTitleController.text == '') {
                    await Dialogs.errorAbortDialog(context,
                        'Name of product is empty.\nPlease fill up the respective field.');
                    print("No listing title inputted");
                    return; //TODO frontend user warning for empty listingTitle/itemName
                  }

                  try {
                    var imageString =
                        image != null && imageURL == 'newimagechosen'
                            ? await storageAccess.uploadFile(image)
                            : imageURL;

                    if (imageURL == 'newimagechosen') {
                      await storageAccess
                          .deleteListingImage(listing.listingImage);
                    }

                    var updatedListing = Listing(
                        userID: uid,
                        listingTitle: listingTitleController.text,
                        longitude: _prediction != null
                            ? _newLocation.longitude
                            : listing.longitude,
                        latitude: _prediction != null
                            ? _newLocation.latitude
                            : listing.latitude,
                        category: valueChoose,
                        isRequest: isselected[1],
                        listingImage: imageString,
                        description: descriptionController.text,
                        isComplete: false);

                    dao.updateListing(widget.listingID, updatedListing);

                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Your listing has been edited.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Acknowledge'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserMain()));
                  } catch (e) {
                    await Dialogs.errorAbortDialog(
                        context, 'Edit unsuccessful! Please try again.');
                    print('Unsuccessful edit: $e');
                    Navigator.of(context).pop();
                  }

                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => Home()));
                }),
          ),
        ]),
      ),
    ));
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
        });
  }

  void _camera() async {
    var _image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (_image == null) {
      print('No image taken.');
      return;
    }
    setState(() {
      image = _image;
      imageURL = 'newimagechosen';
    });
  }

  void _gallery() async {
    var _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (_image == null) {
      print('No image selected.');
      return;
    }
    setState(() {
      image = _image;
      imageURL = 'newimagechosen';
    });
  }
}
