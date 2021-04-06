import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/activity_presenter.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/activity/privatechat.dart';
import 'package:flutter_application_1/screens/common/error_popup_widgets.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/backend/listing_presenter.dart';
import 'package:flutter_application_1/screens/listing/SendListingReport.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../listing/Editinglist_page.dart';
import 'package:flutter_application_1/backend/auth.dart' as auth;

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
    print("Test" + widget.listingID);
    loadAsyncData(widget.listingID).then((response) {
      setState(() {
        listingTitle = response['listing'].listingTitle;
        description = response['listing'].description;
        listingImg = response['listing'].listingImage;
        username = response['poster'].username;
        isComplete = response['listing'].isComplete;
        isAdmin = response['isAdmin'];
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
    await mapHandler.getBytesFromAsset('assets/location_icon.png', 100);
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
  bool isAdmin;
  bool isComplete;
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
    print('isAdmin : $isAdmin');
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text(listingTitle == null ? 'Loading...' : listingTitle,
              style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: offWhite,
        body: listingTitle == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(children: <Widget>[
            listingDetailsTopCard(listingTitle, listingImg, currentuser,
                widget.listingID, isComplete, isAdmin, context),
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
                  zoom: 13.0,
                ),
                markers: _markers,
              ),
            ),
            SizedBox(height: 20),
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
    bool isAdmin = await auth.isAdminCheck(currentUID);
    return {
      'listing': listing,
      'poster': poster,
      'currentUID': currentUID,
      'isAdmin': isAdmin
    };
  }
}

Widget listingDetailsTopCard(
    title, listingImg, currentUser, listingID, isComplete, isAdmin, context) {
  DatabaseAccess dao = DatabaseAccess();

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:  Image.network(
                          listingImg,
                          fit: BoxFit.cover,
                          height: 300.0,
                          width: 300.0,
                        ),
                    ),
                  )
                ),
              SizedBox(height: 30),
            ],
          )),
    ),
    //TODO: Set the functions when the buttons are clicked (for backend ppl)
    ...ownerButtons(currentUser, isAdmin, context, listingID, isComplete,
        // CompleteBtnPressed
            () async {
          try {
            await FirebaseDatabase.instance
                .reference()
                .child('Listing')
                .child(listingID)
                .child('isComplete')
                .set(true);
            //TODO show completion message to user and remove complete button
            await showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Your listing has been completed.'),
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
            print('Listing completed');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserMain()));
          } catch (e) {
            await Dialogs.errorAbortDialog(
                context, 'Completion unsuccessful! Please try again.');
            print('Listing completion unsuccessful: $e');
          }
        },
        // EditBtnPressed
            () {
          print('edit button pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Editinglist_page(),
                  settings: RouteSettings(arguments: {'listingID': listingID})));
        },
        // DeleteBtnPressed
            () async {
          try {
            await dao.deleteListingOnKey(listingID);
            await showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Your listing has been deleted.'),
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
            print('Delete completed');
            Navigator.of(context).pop();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => UserMain()));
          } catch (e) {
            await Dialogs.errorAbortDialog(
                context, 'Deletion unsuccessful! Please try again.');
            print('Deletion unsuccessful: $e');
          }
        }),

    ...normalUserButtons(currentUser, isAdmin, context, listingID,
        //chat btn pressed
            () async {
          String curr = await auth.currentUser();
          Listing listing = await ActivityPresenter().readListing(listingID);
          List<String> msgs = new List<String>();
          msgs.add("defaultempty");

          await ActivityPresenter().addConversation(listingID, listing.userID, curr, msgs);

          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrivateChatScreen(
                    conversation_id: listingID+listing.userID+curr,
                  )));

        }),
  ]);
}

List<Widget> ownerButtons(currentuser, isAdmin, context, listingID, isComplete,
    CompleteBtnPressed, EditBtnPressed, DeleteBtnPressed) {
  if (currentuser == true && isAdmin == false) {
    return [
      Positioned(
        right: 190,
        left: 100,
        bottom: -20,
        child: Container(
            height: 40,
            child: isComplete == false
                ? CustomCurvedButton(
              btnText: 'Complete',
              btnPressed: CompleteBtnPressed,
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                color: Colors.grey[350],
                child: Center(
                  child: Text('Complete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400],
                      )),
                ),
              ),
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
  }
  {
    return <Widget>[];
  }
}

// return a report button only if this is true
List<Widget> normalUserButtons(
    currentuser, isAdmin, context, listingID, chatBtnPressed) {
  if (currentuser == false && isAdmin == false) {
    return [
      Positioned(
          right: 15,
          left: 290,
          bottom: -20,
          child: Container(
            height: 40,
            key: Key('Report'),
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
  } else {
    return <Widget>[];
  }
}
