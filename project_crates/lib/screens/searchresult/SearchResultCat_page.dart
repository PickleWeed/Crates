import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/backend/search_listing_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:flutter_application_1/screens/home/searchdata.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchResultCat_page extends StatefulWidget {
  final String product;
  final String categoryName;
  SearchResultCat_page({this.product, this.categoryName});

  @override
  _SearchResultCat_pageState createState() => _SearchResultCat_pageState();
}

class _SearchResultCat_pageState extends State<SearchResultCat_page>{
  String choosenProduct;
  String choosenCategory;
  final TextEditingController _typeAheadController = TextEditingController();
  List<Listing> listings = [];
  List<User> userDetailList = [];
  bool dataLoading = false;
  SearchListingPresenter _searchListingPresenter = new SearchListingPresenter();
  void getData() async{
    setState(() {
      dataLoading = true;
    });
    await _searchListingPresenter.getMatchingListings(choosenProduct).then((listingList) async {
      for (int i = 0; i < listingList.length; i++) {
        User userDetail =
        await ProfilePresenter().retrieveUserProfile(listingList[i].userID);
        userDetailList.add(userDetail);
      }

      setState(() {
        dataLoading = false;
        listings = listingList;
        userDetailList = userDetailList;
      });
    });

  }
  @override
  initState() {
    super.initState();
    _typeAheadController.text = widget.product;
    choosenProduct = widget.product;
    choosenCategory = widget.categoryName;
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          backgroundColor: Color(0xFFFFC857),
          title: Text('Search Result',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color:Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          width: 300,
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
                    hintText: 'search'),
                controller: _typeAheadController
            ),
            suggestionsCallback: (pattern) async {
              return await StateService()
                  .getListingTilesWithCat(pattern, choosenCategory);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              _typeAheadController.text = suggestion;
              setState(() {
                choosenProduct = suggestion;
              });
              getData();
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => SearchResultCat_page(
              //       product: suggestion,
              //       categoryName: categoryName,
              //     )));
            },
          ),
        ),
        dataLoading == true?
        Text(
        'loading...',
        // Text placement will change depend on the search result
        textAlign: TextAlign.left,
        style: TextStyle(
        color: Colors.grey,
        fontSize: 20,
        fontWeight: FontWeight.bold)):
        SingleChildScrollView(
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment(-0.6, 0),
                  child: Text(
                      '${listings.length} results for "${choosenProduct}"',
                      // Text placement will change depend on the search result
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
              //SizedBox(height: 20),
              listings.isEmpty
                  ? Text("No results found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ))
                  : ListingsArea(userDetailList, listings),
            ])
        )
      ])
      // Body(
      //   searchString: product,
      //   categoryName: categoryName,
      // ),
    );
    // body: Body());
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
