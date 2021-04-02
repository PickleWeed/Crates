import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/Review.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/profile/editProfile.dart';
import '../common/theme.dart';
import '../common/widgets.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String currentUserID;
  User userDetails;
  bool dataLoadingStatus = false;
  List<Listing> userListings;
  List<Listing> userRequestListings;
  ProfilePresenter _profilePresenter = new ProfilePresenter();


  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    loadData();
    super.initState();
  }
  loadData() async{
    setState(() {
      dataLoadingStatus = true;
    });
    currentUserID = await currentUser();
    userDetails = await _profilePresenter.retrieveUserProfile(currentUserID);
    userListings = await _profilePresenter.retrieveUserListing(currentUserID);
    userRequestListings = await _profilePresenter.retrieveUserRequestListing(currentUserID);
    setState(() {
      currentUserID = currentUserID;
      userDetails = userDetails;
      userListings = userListings;
      userRequestListings = userRequestListings;
      dataLoadingStatus = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: offWhite,
        body: dataLoadingStatus == false ?
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 180,
                      child: Card(
                          margin: EdgeInsets.zero,
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(145, 110,0,0),
                                child: Text(
                                  userDetails.username,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: offWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Positioned(
                      right: 20,
                      left: 250,
                      bottom:-20,
                      child: Container(
                          height: 40,
                          child: CustomCurvedButton(
                            btnText: 'Log out',
                            btnPressed: () async {
                              signOut(context);
                            },
                          )
                      ),
                    ),
                    Positioned(
                      right: 120,
                      left: 150,
                      bottom:-20,
                      child: Container(
                          height: 40,
                          child: CustomCurvedButton(
                            btnText: 'Edit',
                            btnPressed: () async {
                              var newDetails = await Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(userModel: userDetails)));
                              print(newDetails);
                              if(newDetails != null){
                                loadData();
                              }
                            },
                          )
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: -40,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userDetails.imagePath),
                        radius: 60,
                      ),
                    ),
                  ]
              ),

              SizedBox(height: 50),
              TabBar(
                  tabs: [
                    Tab(text: 'Normal Listings'),
                    Tab(text: 'Request Listings'),
                  ],
                controller: _tabController,
                ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.count(
                            shrinkWrap : true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2 ,
                            scrollDirection: Axis.vertical,
                            children: List.generate(userListings.length,(index){

                              return CustomListingCard(listingID:userListings[index].listingID, title: userListings[index].listingTitle, owner: userDetails.username,
                                  listingImg: userListings[index].listingImage, ownerImg:userDetails.imagePath);
                            }),
                          ),
                        ),
                    ),
                    //TODO LOAD REQUEST Listing DYNAMICALLY
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          shrinkWrap : true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2 ,
                          scrollDirection: Axis.vertical,
                          children: List.generate(userRequestListings.length,(index){
                            return CustomListingCard(listingID:userRequestListings[index].listingID,
                                title: userRequestListings[index].listingTitle,
                                owner: userDetails.username,
                                listingImg: userRequestListings[index].listingImage,
                                ownerImg:userDetails.imagePath);
                          }),
                        ),
                      ),
                    ),

                  ],
                  controller: _tabController,
                ),
              ),

            ]):Center(child: CircularProgressIndicator())
    );
  }
}
