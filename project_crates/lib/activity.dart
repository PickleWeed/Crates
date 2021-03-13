import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[400],
          title: Text("Activity page",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 0,
            color: Colors.pink,
          ),
        ),
        body: Body());
    // body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

Widget notificationHeader() {
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
                onPressed: () {},
              )))
    ],
  ));
}

List<String> hello = [
  'really?',
  "need to test",
  "seriously edan",
  "last straw alr",
  "maybe need more esting",
  "I need more time",
  "ssy so good",
  "jun wei is the best!",
  "something like that",
  "valorant is the best",
  "Edan is valorant pro",
  "maybe that is a lie"
];
//this is stupid
// building of cards
// Widget building() {
//   return Center(
//     child: Card(
//       semanticContainer: false,
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           print('Card tapped.');
//         },
//         child: Container(
//           width: 400,
//           height: 200,
//           child: Text('A card that can be tapped'),
//         ),
//       ),
//     ),
//   );
// }

class _BodyState extends State<Body> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Notification'),
    Tab(text: 'Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          toolbarHeight: 80,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            notificationHeader(),
            Container(
                child: SingleChildScrollView(
              child: // CHILD 1
                  ListView.builder(
                //CHILD 2
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: hello.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    onTap: () {
                      print("Hello"); // to go  to notifcation
                    },
                    title: Text(hello[index]),
                  ));
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
