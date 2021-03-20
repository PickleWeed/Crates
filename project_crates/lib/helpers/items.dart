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
    onPressed: () {}, //TODO ADD FUNCTION TO GO BACK
    child: Text('Cancel'),
    style: TextButton.styleFrom(primary: Colors.blue),
  );

  String dropdownValue = 'One';
  //set up alert dialog
  AlertDialog alerting = AlertDialog(
      actions: [report, cancel],
      title: Text('seriously hard'),
      content: Column(children: [
        TextField(
          decoration: InputDecoration(labelText: 'Report Title'),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            {
              dropdownValue = newValue;
            }
            ;
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Additional Comment'),
        ),
      ]));
  //show dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerting;
      });
}

@override
State<StatefulWidget> createState() {
  // TODO: implement createState
  throw UnimplementedError();
}
