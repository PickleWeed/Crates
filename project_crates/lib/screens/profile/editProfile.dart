import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/profile_presenter.dart';
import 'package:flutter_application_1/backend/storageAccess.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final User userModel;

  EditProfile({Key key, @required this.userModel}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  var usernameController;
  File image;
  String imageUrl;
  bool _isButtonDisabled;
  ProfilePresenter _profilePresenter = ProfilePresenter();
  StorageAccess storageAccess = StorageAccess();

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.userModel.username);
    _isButtonDisabled = false;
    super.initState();
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Edit Profile'),
    Tab(text: 'Change Password'),
  ];

  // used for validation
  final _usernameForm = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final tabController = DefaultTabController.of(context);
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
            child: TabBarView(children: <Widget>[
              SingleChildScrollView(
                child: Form(
                  key: _usernameForm,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Row(
                        // Circle Avatar
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                backgroundImage: image == null
                                    ? NetworkImage(widget.userModel.imagePath)
                                    : FileImage(image),
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
                              label: Text(
                                'Edit Profile Picture',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                _showPicker(context);
                                print('edit clicked');
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    primaryColor),
                              ))
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Text('Username',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              validator: (value) {
                                // check if empty, or less than 3 characters
                                if (value == null || value.isEmpty) {
                                  return 'Please enter something!';
                                }
                                // use regex to check if username is valid
                                // https://stackoverflow.com/questions/12018245/regular-expression-to-validate-username/12019115
                                Pattern pattern = r'^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
                                var regex = RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Invalid username';

                                return null;
                              },
                              controller: usernameController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '')),
                        ),
                      ),
                      SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(80, 20, 80, 10),
                        child: CustomCurvedButton(
                            btnText: 'Save Changes',
                            btnPressed: () async {
                              if (_usernameForm.currentState.validate()) {
                                if (image == null &&
                                    usernameController.text.toString() ==
                                        widget.userModel.username) {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("No changes made."),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                } else {
                                  if (image != null) {
                                    await _profilePresenter
                                        .deleteCurrentProfilePic(
                                        widget.userModel.imagePath);
                                    imageUrl = await _profilePresenter
                                        .uploadProfilePic(image);
                                    await _profilePresenter.updateUserProfile(
                                        usernameController.text, imageUrl);
                                  } else {
                                    await _profilePresenter.updateUserProfile(
                                        usernameController.text,
                                        widget.userModel.imagePath);
                                  }
                                  var user = await _profilePresenter
                                      .retrieveUserProfile(
                                      widget.userModel.userID);
                                  //print(widget.userModel.userID);
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("Update Successfully"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.pop(context, user);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _passwordForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20),
                        Text('Old Password',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'You need to enter something!';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: oldPasswordController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '')),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20),
                        Text('New Password',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'You need to enter something!';
                              }
                              // check if password is strong enough
                              // Minimum eight characters, at least one letter, one number and one special character:
                              Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
                              var regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Password is too simple!';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: newPasswordController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '')),
                      ),
                    ),

                    //TODO: Fix "RECENT LOGIN REQUIRED" Problem (hopefully wont happen during demo)
                    //TODO: Add proper success and failed alerts
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 80, 10),
                      child: CustomCurvedButton(
                          btnText: 'Change Password',
                          btnPressed: () async {
                          if (_passwordForm.currentState.validate()) {
                            if (oldPasswordController.text != null &&
                                newPasswordController.text != null) {
                              bool passcheck =
                              await _profilePresenter.getCurrentPassword(
                                  widget.userModel.email,
                                  oldPasswordController.text);
                              if (passcheck == true) {
                                _profilePresenter.changePassword(
                                    widget.userModel.email,
                                    newPasswordController.text);
                                print("password succesfully changed");
                              } else {
                                print("wrong old password");
                              }
                            }
                          }
                          }),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      }),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _gallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _camera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _camera() async {
    var _image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (_image == null) {
      print('No image taken.');
      return;
    }
    setState(() {
      image = _image;
    });
  }

  _gallery() async {
    var _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (_image == null) {
      print('No image selected.');
      return;
    }
    setState(() {
      image = _image;
    });
  }
}
