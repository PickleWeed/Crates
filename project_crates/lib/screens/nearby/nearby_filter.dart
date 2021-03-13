import 'package:flutter/material.dart';
import '../common/theme.dart';

class NearbyFilter extends StatefulWidget {
  @override
  _NearbyFilterState createState() => _NearbyFilterState();
}

class _NearbyFilterState extends State<NearbyFilter> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
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
              ] // Populate the Drawer in the next step.
          ),
        ),
        backgroundColor: offWhite,
        body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  topCard(_globalKey),
                  SizedBox(height:50),
                  
                ]
            )
        )

    );
  }
}

Widget topCard(_globalKey){
  return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100,
          child: Card(
              margin: EdgeInsets.zero,
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:42),
                  Center(
                    child: Text(
                      "Filter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 2,
                        color: offWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              )
          ),
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
  );

}