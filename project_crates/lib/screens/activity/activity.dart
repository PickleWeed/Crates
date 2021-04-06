import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/activity_presenter.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/models/Notifications.dart';
import '../activity/notificationpage.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Notification'),
    Tab(text: 'Chat'),
  ];

  bool dataLoading = false;
  List<Notifications> notiList = new List<Notifications>();
  ActivityPresenter _notificationPresenter = new ActivityPresenter();

  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      // Data is still loading
      dataLoading = true;
    });

    notiList =
    await _notificationPresenter.readNotificationList(await currentUser());

    setState(() {
      notiList = notiList;
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
          title: Text("Activity Page",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        body: dataLoading == false ?
        DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                shape: Border(
                  top: BorderSide(color: Theme.of(context).canvasColor),
                ),
                bottom: TabBar(
                  tabs: myTabs,
                  isScrollable: false,
                  indicatorWeight: 3.0,
                  //TODO OnTap Function
                ),
                automaticallyImplyLeading: false,
                toolbarHeight: 60,
              ),
              body: TabBarView(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      notificationHeader(context),
                      Container(
                          child: SingleChildScrollView(
                            child: // CHILD 1
                            ListView.builder(
                              //CHILD 2
                              shrinkWrap: true,
                              //physics: NeverScrollableScrollPhysics(),
                              itemCount: notiList.length,
                              itemBuilder: (context, index) {
                                return notiCard(context, notiList[index]);
                              },
                            ),
                          ))
                    ],
                  ),
                 Container(),
                  // ChatPage(),
                ],
              ),
            )):Center(child: CircularProgressIndicator()),
    );
  }
}

Widget notificationHeader(BuildContext context) {

  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Notifications', style: TextStyle(fontSize: 20)),
          )),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: EdgeInsets.only(right: 10.0),
              child: TextButton.icon(
                icon: Icon(Icons.sort),
                label: Text('Sort'),
                onPressed: () {
                  //TODO LIST.sort() then is sorting done;
                },
              )))
    ],
  ));
}

Widget notiCard(BuildContext context, Notifications noti) {
  return Container(
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
            margin: EdgeInsets.fromLTRB(5, 2, 2, 5),
            child: GestureDetector(
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  title: Text("Update of report on " + noti.reportID),
                  subtitle: Text(noti.notificationText),
                  isThreeLine: false,
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                onTap: () async {
                  // Load other listing details
                  Notifications notification =
                  await ActivityPresenter().readNotification(noti.notificationID);

                  // Call listing to display
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage(noti: notification)));
                }))),
  );
}

