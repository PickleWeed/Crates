import 'package:flutter/material.dart';

abstract class NotifItem {
  //The title line to show in the list
  Widget buildTitle(BuildContext context);

  // to build the subtitle if there is any
  Widget buildSubtitle(BuildContext context);
}

class MessageItem implements NotifItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) {
    return Text(sender);
  }

  Widget buildSubtitle(BuildContext context) {
    return Text(body, overflow: TextOverflow.ellipsis);
  }
}

// do we need heading? probabl not
class HeadingItem implements NotifItem {
  final String heading;
  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

// Widget reportyoufucked(BuildContext context) {
//   return showDialog(context: context,
//   builder: (BuildContext context){
//     return AlertDialog(
//       scrollable: true,
//       title: Text('checking')
//     );
//   });

//   child: Column(children: <Widget>[
// Text('Report you fucked up'),
// DropdownButton<String>(
//     items: <String>[
//   'you toxic',
//   'salty',
//   'being eggxactly',
//   'Finally done for'
// ].map<DropdownMenuItem<String>>((String value) {
//   return DropdownMenuItem<String>(
//     value: value,
//     child: Text(value),
//   );
// })),
// TextFormField(
//   decoration: InputDecoration(labelText: 'Enter your username'),
// ),
//   ]));
// }

showAlertDialog(BuildContext context) {
  // set up button
  Widget report = TextButton(
    onPressed: () {
      //TODO add function to add report into database
    },
    child: Text('Report'),
    style: TextButton.styleFrom(primary: Colors.red),
  );

  Widget cancel = TextButton(
    onPressed: () {},
    child: Text('Cancel'),
    style: TextButton.styleFrom(primary: Colors.blue),
  );

// DropdownButton<String>(
//     items: <String>[
//   'you toxic',
//   'salty',
//   'being eggxactly',
//   'Finally done for'
// ].map<DropdownMenuItem<String>>((String value) {
//   return DropdownMenuItem<String>(
//     value: value,
//     child: Text(value),
//   );

  //set up alert dialog
  AlertDialog alerting = AlertDialog(
    actions: [report, cancel],
    title: Text('seriously hard'),
    content: Text("This is my home"),
  );
  //show dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerting;
      });
}
