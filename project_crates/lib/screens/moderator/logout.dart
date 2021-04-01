import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';


class LogoutAdmin extends StatefulWidget {
  @override
  _LogoutAdminState createState() => _LogoutAdminState();
}


class _LogoutAdminState extends State<LogoutAdmin> {
  bool dataLoading = false;


  void _signOut() async {
    try {
      await signOut(context);
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {

    setState(() {
      // Data is still loading
      dataLoading = true;
    });

    _signOut();

    setState(() {
      // Data is done loading
      dataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Body());
    );}
}

