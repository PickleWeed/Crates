
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Selectedlisting_page.dart';






class SearchResult_page extends StatelessWidget {



  String _search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(70.0))),
            actions: <Widget>[
              Container(
                width: 300,

                child:
                TextField(
                  style: TextStyle(color: Colors.black,height: 0,fontSize: 20),
                  decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Enter Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      filled: true,
                      fillColor: Colors.grey[50]),
                  onChanged: (value) {
                    _search = value
                        .trim(); // store the password typed in the _password
                  },
                ),
              ),



              IconButton(
                alignment: Alignment.center,
                icon: new Icon(Icons.search,size:35),
                color:Colors.black,
                onPressed: () {
                  // pressed to execute search in the search field the user has entered
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchResult_page()));
                },
              ),
            ]


        ),


        body: Body()


    );
    // body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: <Widget>[
            SizedBox(height: 20),
          Align(
              alignment: Alignment(-0.7,0),
              child:
              Text('4 result for "coffee powder"',        // Text placement will change depend on the search result
                textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold)
              )
          ),

          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(
                padding:EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child:
                  MaterialButton(
                    elevation: 1,
                    minWidth:100, // width of the button
                    height: 30,
                    onPressed: () async {
                      // go to flilter page
                    }
                    ,color: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                    child: Text('Fliters',
                        style: TextStyle(color: Colors.grey[600], fontSize: 20)),
                  ),
                ),
              Container(
                child:
                MaterialButton(
                  elevation: 1,
                  minWidth:100, // width of the button
                  height: 30,

                  onPressed: () async {
                    // go to sort page
                  }
                  ,color: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                  child: Text('Sort',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20)),
                ),
              )
                ]
               ),
              //SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                           onTap:() {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Selectedlisting_page()));
                           },
                          child:
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 180,
                            color: Colors.grey[300],
                              child:Image.asset(
                              'assests/google_logo.png',fit:BoxFit.scaleDown ,

                          ),

                            ),
                        ),
                        Container(
                          alignment: Alignment(-0.7,0),
                          width: 180,
                          color: Colors.grey[300],
                            child:Text('food', style: TextStyle(fontSize: 25),)
                        ),
                      Container(
                          padding: EdgeInsets.fromLTRB(13,0,0,10),
                          child:
                          Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment(-0.7,0),
                              width: 180,
                              height: 30,
                              color: Colors.grey[300],
                              child:Text('by: name', style: TextStyle(fontSize: 15),)
                              ),
                            Container(
                              alignment: Alignment(0.7,0),
                              child: CircleAvatar(
                                radius: 13.0,
                                child:Icon(Icons.photo_camera,size: 10,),
                              ),
                            ),

                         ]
                        )
                        )





                    ],
                ),
              ),

                ////////////////////////////////////////////////////////
                Expanded(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap:() {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Selectedlisting_page()));
                        },
                        child:
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 180,
                          color: Colors.grey[300],
                          child:Image.asset(
                            'assests/google_logo.png',fit:BoxFit.scaleDown ,

                          ),

                        ),
                      ),
                      Container(
                          alignment: Alignment(-0.7,0),
                          width: 180,
                          color: Colors.grey[300],
                          child:Text('food', style: TextStyle(fontSize: 25),)
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(13,0,0,10),
                          child:
                          Stack(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment(-0.5,0),
                                    width: 180,
                                    height: 30,
                                    color: Colors.grey[300],
                                    child:Text('by: name', style: TextStyle(fontSize: 15),)
                                ),
                                Container(
                                  alignment: Alignment(0.7,0),
                                  child: CircleAvatar(
                                    radius: 13.0,
                                    child:Icon(Icons.photo_camera,size: 10,),
                                  ),
                                ),

                              ]
                          )
                      )





                    ],
                  ),
                ),
              ]
          ),




            ]
        ),
      ),






    );
  }
}

