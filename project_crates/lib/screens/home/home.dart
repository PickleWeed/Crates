import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/searchresult/SearchResult_page.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import '../Navigationbar.dart';
import '../common/widgets.dart';
import '../common/theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
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
              ]// Populate the Drawer in the next step.
          ),
        ),
        backgroundColor: offWhite,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                topCard(_globalKey),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.fromLTRB(25,0,0,10),
                  child: Text('Categories',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )
                  ),
                ),
                CategoryList(context),
                SizedBox(height:15),
                Padding(
                  padding: EdgeInsets.fromLTRB(25,0,0,10),
                  child: Text('Nearby',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )
                  ),
                ),
                NearbyList(),
                SizedBox(height:20),


              ]
            ),

            ),
      bottomNavigationBar: Navigationbar(0),





    );

  }
}


Widget topCard(_globalKey){
  return Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      Container(
      width: double.infinity,
        height: 200,
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
                SizedBox(height:60),
                Center(
                  child: Text(
                    "CRATES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2,
                      color: offWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ),
                SizedBox(height:30),
                Padding(
                  padding: EdgeInsets.only(left:25),
                  child: Text('search',
                  style: TextStyle(
                    color: offWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
      Positioned(
        right: 45,
        left: 45,
        bottom:-20,
        child: Container(
          height: 50,
          child: TextField(
              decoration: InputDecoration(
                  focusedBorder :OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  prefixIcon: Icon(Icons.search),
                  prefixStyle: TextStyle(
                    decorationColor: Colors.red,

                  ),

                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'search')),
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

Widget CategoryList(context){
  return SizedBox(
    height:140,
    child: ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          height:140.0,
          width: 140.0,
          child: InkWell(
            onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SearchResult_page()));},
            child: Card(

              color: Colors.grey[350],
              margin: EdgeInsets.all(5),


                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                            child: Text('All',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )
                            ),
                          ),
                          Padding(

                            padding: EdgeInsets.fromLTRB(40, 5, 5, 5),
                            child: Image(
                              image: AssetImage('assets/icons/groceries.png'),

                            ),
                          )

                        ]
                    )


                ),

            ),
          ),
        Container(
            height:140.0,
            width: 140.0,
            child: Card(
                color: Colors.grey[350],
                margin: EdgeInsets.all(5),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text('Vegetables',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 5, 5, 5),
                        child: Image(
                            image: AssetImage('assets/icons/broccoli.png')
                        ),
                      )
                    ]
                )
            )
        ),
        Container(
            height:140.0,
            width: 140.0,
            child: Card(
                color: Colors.grey[350],
                margin: EdgeInsets.all(5),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text('Canned Foods',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 5, 5, 5),
                        child: Image(
                            image: AssetImage('assets/icons/cream.png')
                        ),
                      )
                    ]
                )
            )
        ),
        Container(
            height:140.0,
            width: 140.0,
            child: Card(
                color: Colors.grey[350],
                margin: EdgeInsets.all(5),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text('Canned Foods',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 5, 5, 5),
                        child: Image(
                            image: AssetImage('assets/icons/cream.png')
                        ),
                      )
                    ]
                )
            )
        ),
      ],
    )
  );
}

Widget NearbyList(){
  return Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ListingCard(title: "Old Town White Coffee", owner: "leejunwei", listingImg: 'assets/coffee.jpg', ownerImg: 'assets/icons/default.png'),
            ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'),
          ],
        ),
        Row(
          children: [
            ListingCard(title: "Old Town White Coffee", owner: "leejunwei", listingImg: 'assets/coffee.jpg', ownerImg: 'assets/icons/default.png'),
            ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'),
          ],
        ),
      ],
    )
  );
}

