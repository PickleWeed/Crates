

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/screens/nearby/nearby_MapHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('Maker should be display', (){
    //Arrange
    List<LatLng> positions = [];
    final position = LatLng(1.3521, 103.8198);
    positions.add(position);
    //Act
    var markers = MapHandler().generateMarkers(positions);
    //Assert
    print(markers);
    expect(markers != null, true);
  });
}