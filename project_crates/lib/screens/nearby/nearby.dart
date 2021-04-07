import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/MapFilter.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'nearby_MapHandler.dart';
import '../../backend/map_DatabaseHandler.dart';
import 'nearbyFilter.dart';
import 'package:geolocator/geolocator.dart';
import '../common/theme.dart';



class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final Completer<GoogleMapController> _controller = Completer();

  bool _serviceEnabled;
  LocationPermission _permission;
  bool _cardVisibility = false;
  bool _filterMode = false;
  bool dataLoadingStatus = false;
  MapFilter _mapFilter;


  MapHandler mapHandler = MapHandler();
  DataHandler dataHandler = DataHandler();


  Set<Marker> _markers = {};
  List<Listing> _listing;
  List<String> _username;
  List<LatLng> _positions;
  LatLng _center = LatLng(1.3521, 103.8198);

  //initial preset values
  final double distance = 20;
  final String category = 'All';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _runSystem();

  }
   void _checkLocationPermission() async {
      // _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      try {
        _serviceEnabled = await Geolocator.isLocationServiceEnabled();
        _permission = await Geolocator.checkPermission();
        if(_permission == LocationPermission.denied) {
          _permission = await Geolocator.requestPermission();
          if (_permission == LocationPermission.deniedForever) {
            print(_permission);
            print(_serviceEnabled);
            return Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
          }else{
            _center = await mapHandler.getCurrentLocation();
            print(_permission);
            setState(() {
              _center = _center;
            });
          }
        }
        setState(() {
          _serviceEnabled = _serviceEnabled;
          _permission = _permission;
        });
      } catch (e) {
        print(e);
      }
  }



  String title ='';
  String textDistance = '';
  double markerDistance;
  String date = '';
  String user = '';
  String listingID = '';
  String imageUrl;
  String locationInfo = '';

  Future<Set<Marker>> generateMarkersFeature() async {
    var markers = <Marker>[];
    print('generating markers');
    final markerIcon = await mapHandler.getBytesFromAsset('assets/location_icon.png', 100);
    final locationIcon = await mapHandler.getBytesFromAsset('assets/location_icon1.png', 200);
    for (int i=0; i<_listing.length; i++) {
      print(user);
      final marker = Marker(
          markerId: MarkerId(LatLng(_listing[i].latitude, _listing[i].longitude).toString()),
          position: LatLng(_listing[i].latitude, _listing[i].longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            markerDistance = dataHandler.haversine(_listing[i].latitude, _listing[i].longitude, _center.latitude, _center.longitude);
            var convertedDateTime = "${_listing[i].postDateTime.day.toString().padLeft(2,'0')}-${_listing[i].postDateTime.month.toString().padLeft(2,'0')}-${_listing[i].postDateTime.year.toString()}";
            setState(() {
              _cardVisibility = true;
              listingID = _listing[i].listingID;
              user = _username[i];
              date = convertedDateTime;
              title = _listing[i].listingTitle;
              imageUrl = _listing[i].listingImage;
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
    markers.add(
        Marker(
            markerId: MarkerId('location'),
            position: _center,
            icon: BitmapDescriptor.fromBytes(locationIcon),
            infoWindow: InfoWindow(
                title: locationInfo
            )
        )
    );
    return markers.toSet();
  }



  void _runSystem()  async{
    setState(() {
      dataLoadingStatus = true;
      _markers = {};
      _cardVisibility = false;
    });
    print("test$_center");
    await _checkLocationPermission();
    if (_permission == LocationPermission.always || _permission == LocationPermission.whileInUse && _serviceEnabled == true) {
      _center = await mapHandler.getCurrentLocation();
      setState(() {
        _center = _center;
        locationInfo = 'Your current location';
      });
    }else{
      setState(() {
        locationInfo = 'Default location';
      });
    }
    setState(() {
      dataLoadingStatus = false;
    });
    if(_filterMode == false){
        print('go to my location');
        _listing = await dataHandler.retrieveFilteredListing(distance, category, _center);
        _username = await dataHandler.getUsernameList(_listing);
        if(_listing.isNotEmpty) {
          _positions = mapHandler.getPositionFromListing(_listing);
          _markers = await generateMarkersFeature();
          setState(() {
            _markers = _markers;

          });
        } else
          print('listing is empty!');
    }else if(_filterMode == true){
      if(_mapFilter.center != null){
        setState(() {
          _center = _mapFilter.center;
          locationInfo = 'Selected location';
        });
      }
      if (_permission == LocationPermission.always && _serviceEnabled == true) {
        await mapHandler.goToMyLocation(_controller, _center);
      }
      _listing = await dataHandler.retrieveFilteredListing(_mapFilter.distance, _mapFilter.category, _center);
      _username = await dataHandler.getUsernameList(_listing);
      if(_listing.isNotEmpty) {
        _positions = mapHandler.getPositionFromListing(_listing);
        _markers = await generateMarkersFeature();
        setState(() {
          _markers = _markers;
        });
      }

    }
  }
  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }else{
     print("prevent call complete twice");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: offWhite,
        body: dataLoadingStatus == false ? Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: _serviceEnabled,
                myLocationButtonEnabled: _serviceEnabled,
                initialCameraPosition: CameraPosition(
                target: _center , //initial default camera position
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
                      key: Key('filter'),
                      icon: Icon(Icons.filter_alt),
                      iconSize: 30,
                      //TODO: filter button pressed
                      onPressed: () async {
                        _mapFilter = await Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyFilter()));
                        if(_mapFilter != null){
                          setState(() {
                            _filterMode = true;
                            _runSystem();
                            print(_filterMode);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              _cardVisibility == true?
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height:160.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: InkWell(
                      onTap: () {
                        print(listingID);
                        // print('listingIDWidget:'+l);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Selectedlisting_page(listingID: listingID)));
                      },
                      child:   Card(
                          clipBehavior: Clip.none,
                          color: Colors.white,
                          child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: AspectRatio(
                                    aspectRatio: 1/1,
                                    child:  Image.network(
                                      imageUrl,
                                      fit:BoxFit.fitWidth,
                                      alignment: Alignment.center,
                                      height:150,
                                      width: MediaQuery.of(context).size.width,
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
                                            Text(user,
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
                  )
                ],
              ):Column(),
            ]
        ):Center(child: CircularProgressIndicator())
    );
  }
}