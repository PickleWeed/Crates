import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui' as ui;
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