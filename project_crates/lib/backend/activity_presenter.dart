import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/Notifications.dart';
import 'package:flutter_application_1/models/ReportListing.dart';

class ActivityPresenter{

  final _databaseRef = FirebaseDatabase.instance.reference();

  //Get list
  Future<List<Notifications>> readNotificationList(String userID) async{
    List<Notifications> notiList = new List<Notifications>();
    await _databaseRef.child('Notification').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        Notifications noti = new Notifications(notificationID: key, notificationText: value['notificationText'],
            listingID: value['listingID'], reportID: value['reportID'],
            userID: value['userID'], notiDate: DateTime.parse(value['notiDate']) ?? "");
        print(userID.toString());
        print("  " + noti.userID);
        if(noti.userID == userID){
          print("test");
          notiList.add(noti);
        }

      });
    });
    return notiList;
  }

  //Get one instance
  Future<Notifications> readNotification(String notificationID) async{
    DataSnapshot snapshot = await _databaseRef.child('Notification').child(notificationID).once();
    Notifications noti = new Notifications(notificationID: notificationID,
        notificationText: snapshot.value['notificationText'],
        listingID: snapshot.value['listingID'], reportID: snapshot.value['reportID'],
        userID: snapshot.value['userID'],
        notiDate: DateTime.parse(snapshot.value['notiDate']));

    return noti;
  }

  //Get listing
  Future<Listing> readListing(String listingID) async{
    DataSnapshot snapshot = await _databaseRef.child('Listing').child(listingID).once();
    if(snapshot.value != null){
      Listing listing = new Listing(listingID: listingID, listingTitle: snapshot.value['listingTitle'], listingImage: snapshot.value['listingImage'],
          userID: snapshot.value['userID']);
      return listing;
    }
    else{
      DataSnapshot snapshotDeleted = await _databaseRef.child('ListingDeleted').child(listingID).once();
      Listing listing = new Listing(listingID: listingID, listingTitle: snapshotDeleted.value['listingTitle'], listingImage: snapshotDeleted.value['listingImage'],
          userID: snapshotDeleted.value['userID']);
      return listing;
    }
  }

  //Get username of user
  Future<String> readUsername(String userID) async{
    DataSnapshot snapshotName = await _databaseRef.child('users').child(userID).once();
    String name = snapshotName.value['username'];
    return name;
  }

  //Get one report listing
  Future<ReportListing> readReportListing(String reportID) async{
    DataSnapshot snapshot = await _databaseRef.child('ReportListing').child(reportID).once();
    ReportListing reportListing = new ReportListing(reportID: reportID, listingID: snapshot.value['listingID'],
        reportTitle: snapshot.value['reportTitle'], reportOffense: snapshot.value['reportOffense'],
        reportDescription: snapshot.value['reportDescription'], complete: snapshot.value['complete'],
        reportDate: DateTime.parse(snapshot.value['reportDate']), userID: snapshot.value['userID']);

    return reportListing;
  }


}