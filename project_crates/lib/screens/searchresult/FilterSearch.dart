import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FilterSearch extends StatefulWidget {
  FilterSearch({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  final dbRef = FirebaseDatabase.instance.reference().child("___");
  List<Map<dynamic, dynamic>> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///TODO
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                // values.forEach((key, values) {
                //   lists.add(values);
                //   // switch(i){
                //   //   case 1:{
                //   //     dbRef.orderByChild("name").startAt("___").endAt("___" + "\uf8ff").once();
                //   //     break;
                //   //   }
                //   //   case 2:{
                //   //     dbRef.orderByChild("category").equalTo("___").once();
                //   //     break;
                //   //   }
                //   //   case 3:{
                //   //     dbRef.orderByChild("date").startAt("___").once();
                //   //     break;
                //   //   }
                //   }
                // });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name: " + lists[index]["name"]),
                            Text("Category: " + lists[index]["category"]),
                            Text("Date: " + lists[index]["date"]),
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

//queries
//Query sortName = dbRef.orderByChild("name").startAt("___").endAt("___" + "\uf8ff").once() as Query;
//Query sortCategory= dbRef.orderByChild("category").equalTo("___").once() as Query;
//Query sortDate = dbRef.orderByChild("date").startAt("___").once() as Query;
