import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/screens/home/listingsData.dart';
import '../common/widgets.dart';
import '../common/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String category = '';
  List<Listing> listings;
  List<String> username;

  bool dataLoadingStatus = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async{
    setState(() {
      dataLoadingStatus = true;
    });
    listings = await ListingData().getListings(category);
    username = await ListingData().getUsernameList(listings);
    setState(() {
      listings = listings;
      dataLoadingStatus = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: offWhite,
        body: dataLoadingStatus == false ?
        ListView(
            children: <Widget>[
              topCard(),
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
              CategoryList(),
              SizedBox(height:15),
              Padding(
                padding: EdgeInsets.fromLTRB(25,0,0,10),
                child: Text('All Listings',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                ),
              ),
              NearbyList(listings),
              SizedBox(height:30),
            ]):Center(child: CircularProgressIndicator())
    );
  }
}

Widget topCard(){
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

      ]
  );

}

Widget CategoryList(){
  return SizedBox(
      height:140,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
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
                              image: AssetImage('assets/icons/groceries.png')
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

Widget NearbyList(List<Listing> listings){
  print(listings.length);
  List<ListingCard> listing_list = [];

  if(listings.isEmpty){
    print('empty');
  }
  else if(listings == null){
    print('null');
  }
  else{
    // TODO: this is hardcoded data, to remove
    /*listing_list = [
      ListingCard(title: "Old Town White Coffee", owner: "leejunwei", listingImg: 'assets/coffee.jpg', ownerImg: 'assets/icons/default.png'),
      ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'),
      ListingCard(title: "Old Town White Coffee", owner: "leejunwei", listingImg: 'assets/coffee.jpg', ownerImg: 'assets/icons/default.png'),
      ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'),
      ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png')];*/

    for(int i=0; i< listings.length;i++){
      listing_list.add(ListingCard(title: listings[i].listingTitle, owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'));
    }
  }


  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.count(
      shrinkWrap : true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2 ,
      scrollDirection: Axis.vertical,
      // TODO for backend person: modify here to return CustomListingCard() instead!
      children:
      List.generate(listing_list.length,(index){
          return listing_list[index];
      }),
    ),
  );
}

