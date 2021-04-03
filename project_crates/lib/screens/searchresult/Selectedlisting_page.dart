import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/backend/databaseAccess.dart';
import 'package:flutter_application_1/screens/listing/SendListingReport.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../listing/Editinglist_page.dart';

class Selectedlisting_page extends StatefulWidget {
  final String listingID;

  Selectedlisting_page({this.listingID});

  @override
  _Selectedlisting_pageState createState() => _Selectedlisting_pageState();
}

//TODO previous page to pass in listing ID, example given below
//////////////////////////////////////////////////////////////////
// return TextButton(
//   child: Text('test'),
//   onPressed: () {
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => Selectedlisting_page(
//               listingID: '-MX7zj0KP3sQgEkJ2J38', //listingID goes here
//             )));
//   },
// );
/////////////////////////////////////////////////////////////////

class _Selectedlisting_pageState extends State<Selectedlisting_page> {
  @override
  initState() {
    super.initState();
    loadAsyncData(widget.listingID).then((response) {
      setState(() {
        listingTitle = response['listing'].listingTitle;
        description = response['listing'].description;
        listingImg = response['listing'].listingImage;
        username = response['poster'].username;
        currentuser = response['currentUID'] == response['listing'].userID;
        center =
            LatLng(response['listing'].latitude, response['listing'].longitude);
        posted = DateTime.now()
                .difference(response['listing'].postDateTime)
                .inDays
                .toString() +
            ' days ago';
      });
      loadMarker(listingTitle);
    });
  }

  MapHandler mapHandler = MapHandler();
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    print(center);
  }

  loadMarker(String title) async {
    markerIcon =
        await mapHandler.getBytesFromAsset('assets/location_icon.png', 50);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('location'),
          position: center,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(title: title)));
    });
  }

  // TODO: This variable determines what buttons are built (true -> edit button, false-> report and chat buttons)
  bool currentuser;
  String listingTitle;
  String listingImg;
  String username;
  String description;
  String posted;
  var center;
  var markerIcon;
  Set<Marker> _markers = {};

  DatabaseAccess dao = DatabaseAccess();
  ProfilePresenter profilePresenter = ProfilePresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text(listingTitle, style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: offWhite,
        body: listingTitle == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                  listingDetailsTopCard(listingTitle, listingImg, currentuser,
                      widget.listingID, context),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("posted $posted",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              RichText(
                                text: TextSpan(
                                    text: 'by ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: username,
                                        style: TextStyle(
                                            color: Color(0xFFFFC857),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19),
                                      )
                                    ]),
                              )
                            ])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(children: [
                      Text(description,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15, 20, 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Location ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ]),
                  ),
                  Container(
                    color: Colors.grey[300],
                    height: 200,
                    width: 350,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 11.0,
                      ),
                      markers: _markers,
                    ),
                  ),
                  currentuser == true
                      ? Row(
                          children: [
                            Flexible(
                              //padding: EdgeInsets.all(15),
                              child: CustomCurvedButton(
                                btnText: 'Mark as complete',
                                btnPressed: () {
                                  dao.markListingAsComplete(widget.listingID);
                                },
                              ),
                            ),
                            Flexible(
                              //padding: EdgeInsets.all(15),
                              child: CustomCurvedButton(
                                btnText: 'Delete',
                                btnPressed: () async {
                                  await dao
                                      .deleteListingOnKey(widget.listingID);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile()));
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(height:20),
                ]),
                //bottomNavigationBar: Navigationbar(0),
              ));
  }

  Future<String> getUID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future loadAsyncData(String listingID) async {
    Listing listing = await dao.getListing(listingID);
    User poster = await profilePresenter.retrieveUserProfile(listing.userID);
    String currentUID = await getUID();
    return {'listing': listing, 'poster': poster, 'currentUID': currentUID};
  }
}

Widget listingDetailsTopCard(
    title, listingImg, currentUser, listingID, context) {
  return Stack(clipBehavior: Clip.none, children: <Widget>[
    Container(
      width: double.infinity,
      height: 300,
      child: Card(
          margin: EdgeInsets.zero,
          color: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Expanded(
                child: Center(
                  child: Image.network(
                    listingImg,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          )),
    ),
    //TODO: Set the functions when the buttons are clicked (for backend ppl)
    ...ownerButtons(currentUser, context, listingID,
    // CompleteBtnPressed
    () {
      FirebaseDatabase.instance
          .reference()
          .child('Listing')
          .child(listingID)
          .child('isComplete')
          .set(true);
      //TODO show completion message to user and remove complete button
      print('Listing completed');
      },
  // EditBtnPresed
        (){
        print('edit button pressed');
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => Editinglist_page(),
        settings: RouteSettings(arguments: {'listingID': listingID})));
  },
        (){}
  ),

    ...normalUserButtons(currentUser, context, listingID,
        //chat btn pressed
        (){print('Chat button pressed!');}
    ),

  ]);
}

List<Widget> ownerButtons(currentuser, context, listingID, CompleteBtnPressed, EditBtnPressed, DeleteBtnPressed){
  if (currentuser == true) {
    return [
      Positioned(
        right: 190,
        left: 100,
        bottom: -20,
        child: Container(
            height: 40,
            child: CustomCurvedButton(
              btnText: 'Complete',
              btnPressed: CompleteBtnPressed,
            )),
      ),
      Positioned(
      right: 110,
      left: 210,
      bottom: -20,
      child: Container(
      height: 40,
      child: CustomCurvedButton(
      btnText: 'Edit',
      btnPressed: EditBtnPressed,
      )),
      ),
      Positioned(
        right: 10,
        left: 290,
        bottom: -20,
        child: Container(
            height: 40,
            child: CustomCurvedButton(
              btnText: 'Delete',
              btnPressed: DeleteBtnPressed,
            )),
      ),
  ];
  }{
    return <Widget>[];
  }
}

// return a report button only if this is true
List<Widget> normalUserButtons(currentuser, context, listingID, chatBtnPressed) {
  if (currentuser == false) {
    return [
      Positioned(
        right: 15,
        left: 290,
        bottom: -20,
        child: Container(
          height: 40,
          child: CustomCurvedButton(
            btnText: 'Report',
            btnPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SendListingReport(listingID: listingID)));
            },
          ),
        )),
      Positioned(
          right: 110,
          left: 200,
          bottom: -20,
          child: Container(
            height: 40,
            child: CustomCurvedButton(
              btnText: 'Chat',
              btnPressed: chatBtnPressed,
            ),
          ))
    ];
  }else{
    return <Widget>[];
  }
}

