import 'package:flutter/material.dart';
import '../common/theme.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.red[100],
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
        ]
      )

    );
  }
}
