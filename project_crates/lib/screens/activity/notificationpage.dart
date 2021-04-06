import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/activity_presenter.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/Notifications.dart';
import 'package:flutter_application_1/models/ReportListing.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';

class NotificationPage extends StatefulWidget {
  final Notifications noti;
  NotificationPage({@required this.noti});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool dataLoading = false;
  Listing listing = new Listing();
  ReportListing reportListing = new ReportListing();

  ActivityPresenter _notificationPresenter = new ActivityPresenter();
  String usernameListing = "";

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      // Data is still loading
      dataLoading = true;
    });

    listing = await _notificationPresenter.readListing(widget.noti.listingID);
    reportListing = await _notificationPresenter.readReportListing(widget.noti.reportID);
    usernameListing = await _notificationPresenter.readUsername(listing.userID);

    //print(reportListing.reportID);

    setState(() {

      // Data is done loading
      dataLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[400],
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.keyboard_backspace), // need to change
                onPressed: () {
                  Navigator.pop(context);
                });
          }),
          title: Text("Notification",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        body: dataLoading == false
            ? SingleChildScrollView(
              child:
                Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        //backbutton
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Selectedlisting_page(listingID: listing.listingID)));
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      listing.listingImage),
                                  radius: 60,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200.0,
                                    alignment: Alignment.centerLeft,
                                    child: Text.rich(TextSpan(
                                        text: 'Listing ID:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              listing.listingID,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold))
                                        ])),
                                  ),
                                  Container(
                                    width: 200.0,
                                    alignment: Alignment.centerLeft,
                                    child: Text.rich(TextSpan(
                                        text: 'Listing Title:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: listing.listingTitle,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold))
                                        ])),
                                  ),
                                  Container(
                                    width: 200.0,
                                    alignment: Alignment.centerLeft,
                                    child: Text.rich(TextSpan(
                                        text: 'Listed by: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: usernameListing,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold))
                                        ])),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        //picture + listing id:listing name + listed by
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 15.0),
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                      reportListing.reportTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                text: 'Report Type: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: reportListing.reportOffense,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                text: 'Reported on: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: reportListing.reportDate
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Report Description: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                        // text of just report description
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              reportListing.reportDescription,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )),
                        SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 23.0, top: 10.0, right: 23),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: primaryColor)
                              )
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Reply from Admin: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.noti.notificationText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 23.0, top: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.noti.notiDate.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )),
                      ],
                    )
          ),
        ) : Center(child: CircularProgressIndicator()));

  }
}
