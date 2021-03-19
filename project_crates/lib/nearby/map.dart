import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as LocationManager;


class Navi extends StatefulWidget {
  @override
  _NaviMap createState() => _NaviMap();
}

class _NaviMap extends State<Navi> {
  //get model
  double _latitudeData;
  double _longitudeData;
  LatLng _center;
  GoogleMapController mapController;

  _getCurrentLocation() async {
    final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitudeData = geoposition.latitude;
      _longitudeData = geoposition.longitude;
      print(_longitudeData);
      print(_latitudeData);
      //_center =  LatLng(_latitudeData, _longitudeData);
    });
  }
  /*Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }*/

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //markers = Set.from([]);
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /*//GoogleMapController mapController;
  BitmapDescriptor customIcon1;
  Set<Marker> markers;
  createMarker(context) {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/location_icon.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
      print('Found Image');
    }
    else {
      print('cannot find customIcon');
    }
  }*/


  @override
  Widget build(BuildContext context) {
    //createMarker(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nearby'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(_latitudeData, _longitudeData),
            zoom: 15.0,
          ),
         /* markers: markers,
          onTap:  (pos) {
            print(pos);
            Marker f =
            Marker(markerId: MarkerId('1'),icon: customIcon1, position: LatLng(_latitudeData, _longitudeData),
                onTap: (){});
            setState(() {
              markers.add(f);
            });
          },*/
        ),
      ),
    );
  }
}
