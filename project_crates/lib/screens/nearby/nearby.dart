//import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'nearby_MapHandler.dart';
import '../../backend/map_DatabaseHandler.dart';
import 'nearbyFilter.dart';

//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import '../common/NavigationBar.dart';
import '../common/widgets.dart';
import '../common/theme.dart';



class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  //LocationData _locationData;
  //final Completer _completer = new Completer();
  Completer<GoogleMapController> _controller = new Completer();

  Position _locationData;
  bool _serviceEnabled;
  LocationPermission _permission;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  MapHandler mapHandler = new MapHandler();
  DataHandler dataHandler = new DataHandler();


  Set<Marker> _markers = {};
  List<Listing> _listing;
  List<LatLng> _positions;
  static LatLng _center;

  //initial preset values
  final double distance = 20;
  final String category = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _runSystem();
    //Provider.of<ListingListViewModel>(context, listen: false).fetchListings();

  }

  static final CameraPosition _kLake = CameraPosition(
      target: _center,
      zoom : 15);
  static final GoogleMap _map = GoogleMap(
    myLocationEnabled: true,
    myLocationButtonEnabled: true,
  );

  Future<void> _updateMap() async {
    final GoogleMapController controller = await _controller.future;
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    print('my location: $_center');
    controller.moveCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  Future<void> _updateMarkers() async {
      setState(() {
        // ignore: unnecessary_statements
        _markers;
      });
  }

   Future<void> _checkLocationPermission() async {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!_serviceEnabled){
        return Future.error('Location services are disabled.');
      }
      _permission = await Geolocator.checkPermission();
      if(_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if(_permission == LocationPermission.deniedForever) {
          print(_permission);
          print(_serviceEnabled);
          return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        }
      }
      print('got permission');
      _locationData = await Geolocator.getCurrentPosition();
  }
  void _getMyLocation(){
    Future.delayed(Duration(milliseconds: 1000), () {
      mapHandler.getCurrentLocation().then((value) => setState(() {
        _center = value;
      }));
    });
  }


  String title ='';
  String textDistance = '';
  double markerDistance;
  String date = '';
  String user = '';

  Future<Set<Marker>> generateMarkersFeature() async {
    List<Marker> markers = <Marker>[];
    print('generating markers');
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/location_icon.png');
    //List<User> userNames = await dataHandler.getUserList();



    for (int i=0; i<_listing.length; i++) {
      markerDistance = dataHandler.haversine(_listing[i].latitude, _listing[i].longitude, _center.latitude, _center.longitude);
      dataHandler.getUserName(_listing[i].userID).then((value) => user);

      print(user);

      final marker = Marker(
          markerId: MarkerId(LatLng(_listing[i].latitude, _listing[i].longitude).toString()),
          position: LatLng(_listing[i].latitude, _listing[i].longitude),
          icon: icon,
          onTap: () {
            String convertedDateTime = "${_listing[i].postDateTime.day.toString().padLeft(2,'0')}-${_listing[i].postDateTime.month.toString().padLeft(2,'0')}-${_listing[i].postDateTime.year.toString()}";

            setState(() {
              // ignore: unnecessary_statements
              user;
              date = convertedDateTime;
              title = _listing[i].listingTitle;
              if(markerDistance >= 1) {
                textDistance = markerDistance.toStringAsFixed(2)+'km';
              }
              else {
                textDistance = (markerDistance*100).toInt().toString()+'m';
              }
            });
          }
      );
      markers.add(marker);
    }
    return markers.toSet();
  }



  void _runSystem()  async{
    await _checkLocationPermission(); //get GPS permission
    if (_permission == LocationPermission.denied || !_serviceEnabled) {
      _listing = await dataHandler.retrieveAllListing();
      _positions = mapHandler.getPositionFromListing(_listing);
      _markers = await mapHandler.generateMarkers(_positions);
      _updateMarkers();
    }
    else if (_permission == LocationPermission.always && _serviceEnabled == true) {
      print('go to my location');
      _center = await mapHandler.getCurrentLocation();
      _goToMyLocation();
      _listing = await dataHandler.retrieveFilteredListing(distance, category, _center);
      if(_listing.isNotEmpty) {
        _positions = mapHandler.getPositionFromListing(_listing);
        _markers = await mapHandler.generateMarkers(_positions);
        _markers = await generateMarkersFeature();
        _updateMarkers();
      }
      else
        print('listing is empty!');
    }
  }


  @override
  Widget build(BuildContext context) {

    //mapHandler.createMarker(context, customIcon1);
    return Scaffold(
        bottomNavigationBar: NavigationBar(2),
        backgroundColor: offWhite,
        body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
                myLocationEnabled: _serviceEnabled,
                myLocationButtonEnabled: _serviceEnabled,
                initialCameraPosition: CameraPosition(
                target: _center = LatLng(1.3521, 103.8198), //initial default camera position
                zoom: 13.0,
                ),
                markers: _markers,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40,20,0),
                    child: IconButton(
                      icon: Icon(Icons.filter_alt),
                      iconSize: 30,
                      //TODO: filter button pressed
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NearbyFilter())
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height:160.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Card(
                        clipBehavior: Clip.none,
                        color: Colors.white,
                        child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: AspectRatio(
                                  aspectRatio: 1/1,
                                  child: Image.asset(
                                    'assets/coffee.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(title,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )
                                      ),
                                      SizedBox(height:10),
                                      Row(
                                        children: [
                                          Icon(Icons.directions),
                                          SizedBox(width:5),
                                          Text(textDistance,
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height:5),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range),
                                          SizedBox(width:5),
                                          Text(date,
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height:5),
                                      Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(width:5),
                                          Text('HoneyBee',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:80),
                                            child: Icon(Icons.keyboard_arrow_right),
                                          ),
                                        ],
                                      ),
                                    ]
                                ),
                              )
                            ]
                        )
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}