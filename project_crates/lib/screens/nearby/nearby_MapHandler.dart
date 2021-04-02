import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui' as ui;
import 'package:flutter_application_1/models/Listing.dart';
import 'package:google_maps_webservice/places.dart';

class MapHandler {

  ///Please do not use this key without permission - Ray
  final LocationAPIkey = "AIzaSyAyRNoMVH4SOXYO1hfHV9dXEAOpm0bmodw";

  Future<LatLng> getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double _latitudeData = geoposition.latitude;
    double _longitudeData = geoposition.longitude;
    final _center = LatLng(_latitudeData, _longitudeData);
    return _center;
  }

  Future<String> getAddressFromLatLng(userLatitude, userLogitude) async {
    var placename;
    try {
      final geoposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userLatitude,
          userLogitude
      );
      Placemark place = placemarks[0];
      print('${place.street}, ${place.postalCode}, ${place.country}');
      placename = '${place.street}, ${place.postalCode}, ${place.country}';
    } catch(e){
      print(e);
    }
    return placename;
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
          position: location,
          icon: icon,
          onTap: () {

          }
        );
        print('marker added');
        markers.add(marker);
      }
    }
    print('output markers');
    return markers.toSet();
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
  ///Obtain position latitude & longitude for markers
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

  ///obtain LatLng from prediction
  Future<LatLng> getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: LocationAPIkey);  //Same API_KEY as above
    PlacesDetailsResponse detail =
    await _places.getDetailsByPlaceId(prediction.placeId);
    double _latitude = detail.result.geometry.location.lat;
    double _longitude = detail.result.geometry.location.lng;
    return LatLng(_latitude, _longitude);
  }
  Future<void> goToMyLocation(Completer<GoogleMapController> _controller, LatLng _position) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition _kLake = CameraPosition(
        target: _position,
        zoom : 15);
    controller.moveCamera(CameraUpdate.newCameraPosition(_kLake));
  }


}