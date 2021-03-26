import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/user.dart';
import '../common/NavigationBar.dart';
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
    print(userListings);
    print(currentUserID);
    setState(() {
      currentUserID = currentUserID;
      userDetails = userDetails;
      userListings = userListings;
      dataLoadingStatus = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(2),
        backgroundColor: offWhite,
        body: dataLoadingStatus == false ?
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              topCard(userDetails.imagePath, userDetails.username, 86),
              SizedBox(height: 50),
              TabBar(
                  tabs: [
                    Tab(text: 'Listings'),
                    Tab(text: 'Reviews'),
                  ],
                controller: _tabController,
                ),
              Expanded(
                child: TabBarView(
                  children: [

                    SingleChildScrollView(
                        child: Column(
                            children:[
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
                              Row(
                                children: [
                                  ListingCard(title: "Old Town White Coffee", owner: "leejunwei", listingImg: 'assets/coffee.jpg', ownerImg: 'assets/icons/default.png'),
                                  ListingCard(title: "Korean Spicy Noodles Samyang", owner: "Eggxactly", listingImg: 'assets/noodles.jpg', ownerImg: 'assets/icons/default.png'),
                                ],
                              ),
                            ]
                        )),
                  //TODO DYNAMIC LISTING
                  //ListingProfileCard(userListings[index].listingTitle,userDetails.username, userListings[index].listingImage,userDetails.imagePath);

                    ListView(
                      padding:  EdgeInsets.all(8),
                      children: <Widget>[
                        reviewCard('freethings4u', 'assets/icons/default.png', 'very nice young man, thank you!', '5 days'),
                        reviewCard('freethings4u', 'assets/icons/default.png', 'very nice young man, thank you!', '5 days'),
                        reviewCard('freethings4u', 'assets/icons/default.png', 'very nice young man, thank you!', '5 days'),
                        reviewCard('freethings4u', 'assets/icons/default.png', 'very nice young man, thank you!', '5 days'),
                        reviewCard('freethings4u', 'assets/icons/default.png', 'very nice young man, thank you!', '5 days'),
                        SizedBox(height:20),
                      ],
                    ),
                  ],
                  controller: _tabController,
                ),
              ),

            ]):Center(child: CircularProgressIndicator())
    );
  }
}

Widget reviewCard(reviewer, reviewerImg, review, time){
  return Container(
    height:100,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
            backgroundImage: AssetImage(reviewerImg),
            radius: 30,
            ),
            SizedBox(width:15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reviewer,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                ),
                Text(review,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                ),
                Text(time + " ago",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                ),
              ],
            )

          ]
        ),
      )
    )
  );
}

Widget topCard(ownerImg, username, n_reviews){
  return Stack(
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
                      username,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: offWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:145),
                    child: Text(n_reviews.toString() + " reviews",
                      style: TextStyle(
                        color: offWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
        Positioned(
          right: 20,
          left: 290,
          bottom:-20,
          child: Container(
            height: 40,
            child: CustomCurvedButton(
              btnText: 'Edit',
              btnPressed: (){},
            )
          ),
        ),
        Positioned(
          left: 20,
          bottom: -40,
          child: CircleAvatar(
            backgroundImage: NetworkImage(ownerImg),
            radius: 60,
          ),
        ),
      ]
  );

}

//listing card for profile
Widget ListingProfileCard(title,owner,listingImg,ownerImg){
  return Expanded(
      child: Container(
        child: InkWell(
          //TODO: Edit this function to add listing page logic
          onTap: (){print(title + " tapped!");},
          child: Card(
              color: Colors.grey[350],
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //***********///
                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network(
                          listingImg,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height:10),
                      Text(title,
                          maxLines: 1, // ensure long titles do not make card taller
                          overflow: TextOverflow.ellipsis, // adds the '...' at the end of long titles
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )
                      ),
                      SizedBox(height:5),
                      Row(
                        children: [
                          CircleAvatar(
                            //***********///
                            backgroundImage: NetworkImage(ownerImg),
                            radius:15,
                          ),
                          SizedBox(width: 6),
                          Text(owner),
                        ],
                      ),
                    ]
                ),
              )
          ),
        ),
      )
  );

}