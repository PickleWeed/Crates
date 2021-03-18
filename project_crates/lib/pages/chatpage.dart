import 'package:flutter/material.dart';
import 'package:projectcrates/helpers/items.dart';
import 'package:projectcrates/activity.dart';
import 'package:projectcrates/pages/notificationpage.dart';

class ChatPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          chatHeader(),
          Container(
              child: SingleChildScrollView(
            child: // CHILD 1
                ListView.builder(
              //CHILD 2
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemCount: hello.length,
              itemBuilder: (context, index) {
                final item = hello[index];
                return Card(
                    child: ListTile(
                  leading:
                      FlutterLogo(), //  TODO how to change to profile picture
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                //TODO change to chatpage
                                messageitem:
                                    hello[index]))); // to go  to notifcation
                  },
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                  trailing: Icon(Icons
                      .keyboard_arrow_right), //TODO need to change the icon to arrow
                  isThreeLine: true,
                ));
              },
            ),
          ))
        ],
      ),
    );
  }
}

// create chat header
Widget chatHeader() {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Chat', style: TextStyle(fontSize: 20)),
          )),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: EdgeInsets.only(right: 10.0),
              child: TextButton.icon(
                icon: Icon(Icons.sort),
                label: Text('Sort'),
                onPressed: () {},
              )))
    ],
  ));
}
