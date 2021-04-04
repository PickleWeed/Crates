import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/databaseAccess.dart';
import 'package:flutter_application_1/backend/match_presenter.dart';
import 'package:flutter_application_1/backend/storageAccess.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/ListingImageData.dart';
import 'package:flutter_application_1/screens/common/error_popup_widgets.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
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
                    BorderRadius.vertical(bottom: Radius.circular(15.0))),
            title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                        Text(
                          'New Listing',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ]))
                ])),
        body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  initState() {
    super.initState();
    getUID().then((uid) {
      setState(() {
        userid = uid;
      });
    });
    valueChoose = listItem[0];
  }

  String userid;
  List<bool> isselected = [true, false];
  List<String> listItem = [
    'Beverages',
    'Canned Food',
    'Dairy Product',
    'Dry Food',
    'Snacks',
    'Vegetables',
  ];
  String valueChoose;
  File image;

  final listingTitleController = TextEditingController();
  final descriptionController = TextEditingController();

  DatabaseAccess dao = DatabaseAccess();
  StorageAccess storageAccess = StorageAccess();

  MapHandler _mapHandler = MapHandler();
  Prediction _prediction;
  LatLng _currentLocation;
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        //body: Center(
        child: Container(
          color: offWhite,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                InkWell(
                  key: Key('image'),
                  onTap: () async {
                    _showPicker(context);
                  },
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: image != null
                          ? Image.file(
                              image,
                              height: 200,
                              width: 200,
                            )
                          : Container(
                              height: 200.0,
                              width: 200.0,
                              color: Colors.grey[350],
                              child: Icon(Icons.photo_camera,
                                  color: Colors.white, size: 50.0),
                            ),
                    ),
                  ),
                ),
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
                          child:
                              Text('Giving away', style: TextStyle(fontSize: 17)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Requesting for ',
                              style: TextStyle(fontSize: 17)),
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
                        key: Key('category'),
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
                          return DropdownMenuItem(
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
                            focusedBorder :OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'name of the item')
                    )
                    ,
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
                          minLines: 4,//Normal textInputField will be displayed
                          maxLines: 4,
                          style: TextStyle(fontSize: 16),
                          controller: descriptionController,
                          decoration: InputDecoration(
                              focusedBorder :OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'description of the item')
                      ),
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
                          style: TextStyle(fontSize: 16),
                          controller: addressController,
                          onTap: () async {
                            _prediction = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: _mapHandler.LocationAPIkey,
                                mode: Mode.overlay, // Mode.fullscreen
                                language: 'en');
                            if (_prediction != null) {
                              var _selected =
                                  await _mapHandler.getLatLng(_prediction);

                              setState(() {
                                _currentLocation = _selected;
                                addressController.text = _prediction.description;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder :OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'pick a location')
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(100, 5, 100, 20),
                  child: CustomCurvedButton(
                    btnKey: 'CreateListing',
                    btnText: 'Create Listing',
                    btnPressed: () async {
                      // validation
                      if (image == null) {
                        await Dialogs.errorAbortDialog(
                            context, 'Please select a photo!');
                        print('No image uploaded');
                        return;
                      }

                      if (valueChoose == null) {
                        final action = await Dialogs.errorAbortDialog(
                            context, 'Please select a category!');
                        print('No category selected');
                        return;
                      }

                      if (listingTitleController.text == '') {
                        final action = await Dialogs.errorAbortDialog(
                            context, 'Name of product cannot be empty!');
                        print('No listing title inputted');
                        return;
                      }

                      if (_currentLocation == null) {
                        await Dialogs.errorAbortDialog(
                            context, 'Address cannot be empty!\n');
                        print('No location selected');
                        return;
                      }

                      // upload image
                      var imageString = await storageAccess.uploadFile(image);

                      // classify image
                      var mp = MatchPresenter();
                      var classifications = await mp.fetchCategories(imageString);

                      // if it is a request listing, then try to find matches
                      var matches;
                      if (isselected[1]) {
                        matches = await mp.getMatches(classifications);
                      }

                      // if there are matches, display matches dialog
                      if (isselected[1] && matches != null) {
                        print(matches.length);
                        print('At least one match was found!');

                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return matchesDialog(context, matches, () async {
                                // user clicks on "Post Anyway"
                                var listingID = await postListing(
                                  context,
                                  dao,
                                  userid,
                                  listingTitleController.text,
                                  _currentLocation.longitude,
                                  _currentLocation.latitude,
                                  valueChoose,
                                  isselected[1],
                                  imageString,
                                  descriptionController.text,
                                );

                                // close popup
                                await Navigator.of(context).pop();

                                // push replace home page
                                await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserMain()));
                                return;
                              });
                            });
                      } else {
                        // post listing
                        await print('No matches, or not a Request listing!');
                        var listingID = await postListing(
                          context,
                          dao,
                          userid,
                          listingTitleController.text,
                          _currentLocation.longitude,
                          _currentLocation.latitude,
                          valueChoose,
                          isselected[1],
                          imageString,
                          descriptionController.text,
                        );

                        // add image classification for this listing to db
                        var temp = await ListingImageData(
                            listingID: listingID, categories: classifications);
                        await mp.addListingImageData(temp);

                        // push replace home page
                        await Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => UserMain()));
                      }
                    },
                  )
                ),
              ]),
        ),
      ),
    );
  }

  Future<String> getUID() async {
    var user = await FirebaseAuth.instance.currentUser();
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
                      key : Key('PhotoLibrary'),
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _gallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    key : Key('Camera'),
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
    });
  }
}

// builds the pop dialog
// TODO: need to pass in data of the matched listings
Widget matchesDialog(context, List<Listing> matches, postAnyway) {
  return AlertDialog(
      title: Text('Hold on! We found some matches!'),
      content: Container(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: matches.length,
          itemBuilder: (BuildContext context, int index) {
            return matchCard(matches[index].listingTitle,
                matches[index].description, matches[index].listingImage, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Selectedlisting_page(
                      listingID: matches[index].listingID)));
            });
          },
        ),
      ),
      actions: [
        TextButton(child: Text('Post Anyway'), onPressed: postAnyway),
        TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ]);
}

// builds each matched row
Widget matchCard(String title, String description, String listingImg, onTap) {
  return InkWell(
    key: Key('popup'),
    onTap: onTap,
    child: Card(
        margin: EdgeInsets.fromLTRB(5, 2, 2, 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                listingImg), // no matter how big it is, it won't overflow
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          title: Text(
            title,
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          subtitle: Text(
            description,
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
          isThreeLine: false,
          trailing: Icon(Icons.keyboard_arrow_right),
        )),
  );
}

Future<String> postListing(context, dao, userid, title, loc_long, loc_lat, cat,
    isselected, imageString, description) async {
  // create listing
  var newListing = await Listing(
    userID: userid,
    listingTitle: title,
    longitude: loc_long,
    latitude: loc_lat,
    category: cat,
    isRequest: isselected,
    listingImage: imageString,
    isComplete: false,
    description: description,
  );

  var listingID = await dao.addListing(newListing);

  return listingID;
}
