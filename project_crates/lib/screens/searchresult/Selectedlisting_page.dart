import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import '../listing/Editinglist_page.dart';

class Selectedlisting_page extends StatefulWidget {
  @override
  _Selectedlisting_pageState createState() => _Selectedlisting_pageState();
}

class _Selectedlisting_pageState extends State<Selectedlisting_page> {

  // TODO: This variable determines what buttons are built (true -> edit button, false-> report and chat buttons)
  final bool currentuser = false; // this dictate if the user click on his own food or others (true->owner of food), (false->other people food)
  String listingTitle = "Samyang Korean Noodles";
  String listingImg = 'assets/coffee.jpg';
  String username = "leejunwei";
  String description = "This is my packet of coffee!";
  String posted = "one week ago";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: offWhite,
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            listingDetailsTopCard(listingTitle, listingImg, currentuser),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("posted $posted",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'by ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: username,
                                  style: TextStyle(
                                      color: Color(0xFFFFC857),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                )
                              ]
                          ),
                        )

                      ]
                  )

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  children:[
                    Text(description,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                  ]
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Location ',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
            ]
            ),
          ),

            Container(
              color: Colors.grey[300],
              height: 150,
              width: 350,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
              ),
            )
          ]),
          //bottomNavigationBar: Navigationbar(0),
        ));
  }
}


Widget listingDetailsTopCard(title, listingImg, currentUser){
  return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 300,
          child: Card(
              margin: EdgeInsets.zero,
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:30),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: offWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      //TODO: Edit this line to use NetworkImage (for backend ppl)
                      child: Image.asset(listingImg,
                        fit:BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(height:30),
                ],
              )
          ),
        ),
        //TODO: Set the functions when the buttons are clicked (for backend ppl)
        reportButton(currentUser, (){}),
        chatEditButtons(currentUser, (){}, (){})
      ]
  );
}

// return a report button only if this is true
Widget reportButton(currentuser, btnPressed){
  print(currentuser);
  if (currentuser == false){
    return Positioned(
      right: 110,
      left: 200,
      bottom:-20,
      child: Container(
          height: 40,
          child: CustomCurvedButton(
            btnText: 'Report',
            btnPressed: btnPressed,
          )
      ),
    );
  }

  return Row();
}
Widget chatEditButtons(bool currentuser, EditBtnPressed, ChatBtnPressed){
  if (currentuser == true){
    return Positioned(
      right: 20,
      left: 290,
      bottom:-20,
      child: Container(
          height: 40,
          child: CustomCurvedButton(
            btnText: 'Edit',
            btnPressed: EditBtnPressed,
          )
      ),
    );
  }else{
    return Positioned(
      right: 20,
      left: 290,
      bottom:-20,
      child: Container(
          height: 40,
          child: CustomCurvedButton(
            btnText: 'Chat',
            btnPressed: ChatBtnPressed,
          )
      ),
    );
  }
}