import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';

class EditProfile extends StatefulWidget  {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Edit Profile'),
    Tab(text: 'Change Password'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            bottom: const TabBar(
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              tabs: tabs,
            ),
          ),
          body: Container(
            color: offWhite,
            child: TabBarView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height:50),
                    Row( // Circle Avatar
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: (){print("Change Photo tapped");},
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/default.png'),
                              radius: 80,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                            label: Text('Edit Profile Picture',
                              style: TextStyle(
                                color: Colors.white,
                              ),),
                            icon: Icon(Icons.edit),
                            onPressed: (){print('edit clicked');},
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                            )
                        )
                      ],
                    ),
                    SizedBox(height:20),
                    Row(
                      children: <Widget>[
                        SizedBox(width:20),
                        Text('Username',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                        SizedBox(width:20),
                      ],
                    ),
                    SizedBox(height:20),
                    Container(
                      height:50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0 ,20 ,0),
                        child: TextField(
                            decoration: InputDecoration(
                                focusedBorder :OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '')
                        ),
                      ),
                    ),
                    SizedBox(width:20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80,20, 80, 10),
                      child: CustomCurvedButton(btnText: 'Save Changes', btnPressed: (){}),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height:50),
                    Row(
                      children: <Widget>[
                        SizedBox(width:20),
                        Text('Old Password',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Container(
                      height:50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0 ,20 ,0),
                        child: TextField(
                            decoration: InputDecoration(
                                focusedBorder :OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '')
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      children: <Widget>[
                        SizedBox(width:20),
                        Text('New Password',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Container(
                      height:50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0 ,20 ,0),
                        child: TextField(
                            decoration: InputDecoration(
                                focusedBorder :OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '')
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80,20, 80, 10),
                      child: CustomCurvedButton(btnText: 'Change Password', btnPressed: (){}),
                    ),
                  ],
                ),

             
              ]
            ),
          ),
        );
      }),
    );
  }
}
