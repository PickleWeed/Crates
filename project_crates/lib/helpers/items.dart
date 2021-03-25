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

Widget reportFormat(BuildContext context) {
  return Container(
      child: Column(
    children: [
      Container(
        alignment: Alignment(-1, -1),
        child: TextButton.icon(
            icon: Icon(Icons.keyboard_backspace),
            label: Text('Back'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ), //backbutton
      Row(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            margin: const EdgeInsets.all(15.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Icon(Icons.favorite,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'HERE COMES THE PARTY!'),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('ListingID:'),
              ),
              Container(
                  alignment: Alignment.centerLeft, child: Text('ListingName'))
            ],
          )
        ],
      ), //picture + listing id:listing name + listed by
      Container(
          margin: const EdgeInsets.only(left: 23.0, top: 15.0),
          alignment: Alignment.centerLeft,
          child: Text('Title of report')), // title of report
      Container(
          margin: const EdgeInsets.only(left: 23.0, top: 10.0),
          alignment: Alignment.centerLeft,
          child: Text('Reported by')), //reported by
      Container(
          margin: const EdgeInsets.only(left: 23.0, top: 10.0),
          alignment: Alignment.centerLeft,
          child: Text('Reported on')), //date of report
      Container(
          margin: const EdgeInsets.only(left: 23.0, top: 10.0),
          alignment: Alignment.centerLeft,
          child:
              Text('Report Description: ')), // text of just report description
      Container(
          margin: const EdgeInsets.only(left: 23.0, top: 10.0),
          alignment: Alignment.centerLeft,
          child: Text('Descriptions')),
      Container(child: chooseActions(context)),
    ],
  ));
}

Widget chooseActions(BuildContext context) {
  return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content: Stack(
              overflow: Overflow.visible,
              children: [
                MyCheckboxTesting(),
              ],
            ));
          },
        );
      }, //show popup dialog
      child: Text('Choose Actions'));
}

Widget dismissReport(BuildContext context) {
  return TextButton(
      style: TextButton.styleFrom(
          primary: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        ;
      }, //show popup dialog
      child: Text('Dimiss Report'));
}

class MyCheckboxTesting extends StatefulWidget {
  @override
  _MyCheckboxTestingState createState() => _MyCheckboxTestingState();
}

class _MyCheckboxTestingState extends State<MyCheckboxTesting> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Seriously I am doomed...'),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
        });
      },
    );
  }
}
