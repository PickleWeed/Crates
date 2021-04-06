import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/screens/home/searchdata.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchResultCat_page extends StatelessWidget {
  String _search;
  final String product;
  final String categoryName;
  SearchResultCat_page({this.product, this.categoryName});

  //TODO: Fix appbar ui(searchbar)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          backgroundColor: Color(0xFFFFC857),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(70.0))),
          actions: <Widget>[
            Container(
              width: 270,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        prefixIcon: Icon(Icons.search),
                        prefixStyle: TextStyle(
                          decorationColor: Colors.red,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'search')),
                suggestionsCallback: (pattern) async {
                  return await StateService()
                      .getListingTilesWithCat(pattern, categoryName);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSuggestionSelected: (suggestion) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchResultCat_page(
                            product: suggestion,
                            categoryName: categoryName,
                          )));
                },
              ),
            ),

            // pressed to execute search in the search field the user has entered
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchResult_page()));
          ]),
      body: Body(
        searchString: product,
        categoryName: categoryName,
      ),
    );
    // body: Body());
  }
}

class Body extends StatefulWidget {
  final String searchString;
  final String categoryName;
  Body({this.searchString, this.categoryName});
  @override
  _BodyState createState() => _BodyState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _BodyState extends State<Body> {
  @override
  initState() {
    super.initState();
    getMatchingListings(widget.searchString).then((listingList) async {
      for (int i = 0; i < listingList.length; i++) {
        User userDetail =
            await ProfilePresenter().retrieveUserProfile(listingList[i].userID);
        userDetailList.add(userDetail);
      }

      setState(() {
        listings = listingList;
        userDetailList = userDetailList;
      });
    });
  }

  Future<List<Listing>> getMatchingListings(String query) async {
    List<Listing> listingList = [];
    await FirebaseDatabase.instance
        .reference()
        .child('Listing')
        .orderByChild('listingTitle')
        .startAt(query)
        .endAt(query + '\uf8ff')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data == null) return listingList;
      data.forEach((key, value) {
        Listing newListing = Listing(
          listingID: key,
          category: value['category'],
          isRequest: value['isRequest'],
          listingImage: value['listingImage'],
          latitude: value['latitude'],
          listingTitle: value['listingTitle'],
          description: value['description'],
          postDateTime: DateTime.parse(value['postDateTime']),
          userID: value['userID'],
          longitude: value['longitude'],
          isComplete: value['isComplete'],
        );
        listingList.add(newListing);
      });
    });
    return listingList;
  }

  List listItem = [
    'Beverages',
    'Canned Food',
    'Dairy Product',
    'Dry Food',
    'Snacks',
    'Vegetables',
  ];
  String valueChoose;
  String _distance;
  List<Listing> listings = [];
  List<User> userDetailList = [];

  Future<void> showFliterDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          bool isChecked = false;
          valueChoose;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                child: setupFliterDialoadContainer(),
                height: 200,
                width: 300,
              ),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: MaterialButton(
                          elevation: 1,
                          minWidth: 100,
                          // width of the button
                          height: 30,
                          onPressed: () async {
                            // clear the filter
                          },
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),

                          child: Text('Clear',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 20)),
                        ),
                      ),
                      Container(
                        child: MaterialButton(
                          elevation: 1,
                          minWidth: 100,
                          // width of the button
                          height: 30,

                          onPressed: () async {
                            // apply
                          },
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(150.0)),

                          child: Text('Apply',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 20)),
                        ),
                      )
                    ]),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //body: Center(
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          Align(
              alignment: Alignment(-0.7, 0),
              child: Text(
                  '${listings.length} results for "${widget.searchString}"',
                  // Text placement will change depend on the search result
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),

          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: MaterialButton(
                    elevation: 1,
                    minWidth: 100,
                    // width of the button
                    height: 30,
                    onPressed: () async {
                      await showFliterDialog(context);
                    },
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),

                    child: Text('Filters',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 20)),
                  ),
                ),
              ]),
          //SizedBox(height: 20),
          listings.isEmpty
              ? Text("No results found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ))
              : ListingsArea(userDetailList, listings),
        ]),
      ),
    );
  }

  setupFliterDialoadContainer() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Text("Filters",
                      // Text placement will change depend on the search result
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Text("category",
                      // Text placement will change depend on the search result
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.normal))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButton(
                    hint: Text(
                      'Select category',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    value: valueChoose,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoose = newValue;
                      });
                    },
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  )),
            ),
            Container(
              child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Text("distance",
                      // Text placement will change depend on the search result
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.normal))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //change here don't //worked
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("within",
                        // Text placement will change depend on the search result
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: TextFormField(
                            //initialValue: userData.name,
                            decoration: InputDecoration(
                                hintText: '  eg 2', fillColor: Colors.grey),

                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                            validator: (val) => val.isEmpty ? 'distance' : null,

                            onChanged: (val) => setState(() => _distance = val),
                          ),
                        ),
                      ),
                    ),
                    Text("kilometers",
                        // Text placement will change depend on the search result
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                  ]),
            ),
          ],
        ));
  }
}

Widget ListingsArea(List<User> userDetailList, List<Listing> listings) {
  List<CustomListingCard> listing_list = [];

  for (int i = 0; i < listings.length; i++) {
    listing_list.add(CustomListingCard(
        listingID: listings[i].listingID,
        title: listings[i].listingTitle,
        owner: userDetailList[i].username,
        listingImg: listings[i].listingImage,
        ownerImg: userDetailList[i].imagePath));
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: List.generate(listing_list.length, (index) {
          return listing_list[index];
        })),
  );
}
