import 'package:flutter/material.dart';
import '../activity/items.dart';
import '../activity/chatpage.dart';
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


  // testing of notif
  List<NotifItem> notifications = [
    MessageItem('Sender Edan :)', 'Message body is empty!'),
    MessageItem('Sender hello!', 'but really I am still testing only')
  ];

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
        body: DefaultTabController(
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
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                //TODO: BACKEND POPULATE HERE
                                final item = notifications[index];
                                return Card(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NotificationPage(
                                                    messageitem: notifications[index]))); // to go  to notifcation
                                      },
                                      title: item.buildTitle(context),
                                      subtitle: item.buildSubtitle(context),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                    ));
                              },
                            ),
                          ))
                    ],
                  ),
                 Container(),
                  // ChatPage(),
                ],
              ),
            )),
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

