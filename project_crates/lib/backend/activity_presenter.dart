import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/models/Notifications.dart';

class ActivityPresenter{

  final _databaseRef = FirebaseDatabase.instance.reference();

  //Get list
  Future<List<Notifications>> readNotificationList() async{
    List<Notifications> reportListingActionList = new List<Notifications>();
    await _databaseRef.child('Notification').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        Notifications reportListingAction = new Notifications(notificationID: key, notificationText: value['notificationText'],
            listingID: value['listingID'], reportID: value['reportID'],
            userID: value['userID'], notiDate: DateTime.parse(value['notiDate']));
        reportListingActionList.add(reportListingAction);
      });
    });
    return reportListingActionList;
  }

  //Get one instance
  Future<Notifications> readNotification(String notificationID) async{
    DataSnapshot snapshot = await _databaseRef.child('Notification').child(notificationID).once();
    Notifications reportListingAction = new Notifications(notificationID: notificationID,
        notificationText: snapshot.value['notificationText'].cast<String>(),
        listingID: snapshot.value['listingID'], reportID: snapshot.value['reportID'],
        userID: snapshot.value['userID'],
        notiDate: DateTime.parse(snapshot.value['notiDate']));

    return reportListingAction;
  }

}