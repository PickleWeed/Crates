import 'package:flutter/material.dart';

class LogoutAdmin extends StatefulWidget {
  @override
  _LogoutAdminState createState() => _LogoutAdminState();
}

//
// List of reports
//

class _LogoutAdminState extends State<LogoutAdmin> {
  bool dataLoading = false;


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



    setState(() {
      // Data is done loading
      dataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataLoading == false
            ? Container(): Center(child: CircularProgressIndicator()));
    // body: Body());
  }
}

