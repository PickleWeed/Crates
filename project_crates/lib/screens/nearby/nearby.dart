import 'package:flutter/material.dart';
import '../common/theme.dart';
import 'dart:async';

//gmaps
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(1.3521, 103.8198);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ]// Populate the Drawer in the next step.
          ),
        ),
      key: _globalKey,
      backgroundColor: offWhite,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
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
                  onPressed: (){},
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
                            Text("Old Town White Coffee",
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
                                Text("200m away",
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
                                Text("12/02/2021",
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
                                Text("HoneyBee",
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
          Padding(
            padding: EdgeInsets.fromLTRB(10, 35, 0,0),
            child: IconButton(
              iconSize: 30,
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: (){
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
        ]
      )

    );
  }
}
