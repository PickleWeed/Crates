import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFilter{
  final LatLng center;
  final double distance;
  final String category;

  MapFilter({this.center,this.distance,this.category});
}