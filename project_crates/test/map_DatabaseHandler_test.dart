import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/backend/map_DatabaseHandler.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('Haversine', (){
    double lat1 = 1.3521, lat2 = 1.3644, lon1 = 103.9915, lon2 = 103.8198;

    //Act
    var result = DataHandler().haversine(lat1, lon1, lat2, lon2);
    //Assert
    print(result);
    expect(result != null, true);
  });

}