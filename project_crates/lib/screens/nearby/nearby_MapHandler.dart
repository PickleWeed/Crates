import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:location/location.dart' as LocationManager;
import 'package:flutter_application_1/models/Listing.dart';

class MapHandler {

  Future<LatLng> getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double _latitudeData = geoposition.latitude;
    double _longitudeData = geoposition.longitude;
    final _center = LatLng(_latitudeData, _longitudeData);
    return _center;
  }

  //TODO same as above, nv use
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

  void getAddressFromLatLng() async {
    try {
      final geoposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          geoposition.latitude,
          geoposition.longitude
      );
      Placemark place = placemarks[0];
      print('${place.locality}, ${place.postalCode}, ${place.country}');
    } catch(e){
      print(e);
    }
  }
  // TODO Useless
  Future<double> getLatitudeDouble() async {
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return geoposition.latitude;
  }
  // TODO Useless
  Future<double> getLongitudeDouble() async {
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return geoposition.longitude;
  }
  //TODO to be removed
  createMarker(context, customIcon1) {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/location_icon.png')
          .then((icon) {
        customIcon1 = icon;
      });
      print('Found Image');
    }
    else {
      print('cannot find customIcon');
    }
  }
  Future<Set<Marker>> generateMarkers(List<LatLng> positions) async {
    List<Marker> markers = <Marker>[];
    print('generating markers');
    for (final location in positions) {
      if (location != null) {
        final icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(10, 10)), 'assets/location_icon.png');

        final marker = Marker(
          markerId: MarkerId(location.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: icon,
        );
        print('marker added');
        markers.add(marker);
      }
    }
    print('output markers');
    return markers.toSet();
  }
  //get position latitude & longitude for markers
  List<LatLng> getPositionFromListing(List<Listing> listing){
    print(listing.length);
    print('getting positions');
    List<LatLng> positions = [];
    for (var location in listing) {
      positions.add(LatLng(location.latitude, location.longitude));
      print('position: $positions');
    }
    return positions;
  }

}