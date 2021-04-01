import 'package:location/location.dart';

class LocationService {
  final Location location = new Location();

  //asks user for permission to access their location then returns latitude and longitude in that order in a List if permission granted, if permission not granted returns null
  Future<List<double>> getLatLong() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    List<double> resultList = [];

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    resultList.add(_locationData.latitude);
    resultList.add(_locationData.longitude);
    return resultList;
  }
}
