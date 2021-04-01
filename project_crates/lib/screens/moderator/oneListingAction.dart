import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/backend/moderator_presentor.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/models/ReportListing.dart';
import 'package:flutter_application_1/models/ReportListingAction.dart';
import 'package:flutter_application_1/screens/common/theme.dart';

enum Penalties { temporary, permanent, none }

class ListingActionForm extends StatefulWidget {
  final ReportListing reportListing;
  final Listing listing;

  ListingActionForm({@required this.reportListing, @required this.listing});

  @override
  _ListingActionFormState createState() => _ListingActionFormState();
}

class _ListingActionFormState extends State<ListingActionForm> {
  String _currentReasonToR;
  String _currentReasonToO;

  TextEditingController reasonToR = TextEditingController();
  TextEditingController reasonToO = TextEditingController();

  Penalties _penalty = Penalties.none;

  //Whether or not listing should be deleted
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: Text("Reported Listing",
                style: TextStyle(fontSize: 30, color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0))),
          ),
          body: ListView(
            children: [Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Actions ',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.only(left: 20.0),
                    title: const Text('Delete Listing'),
                    value: _isSelected,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isSelected = newValue;
                      });
                    },
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Ban Account for 1 month'),
                        leading: Radio<Penalties>(
                          value: Penalties.temporary,
                          groupValue: _penalty,
                          toggleable: true,
                          onChanged: (Penalties value) {
                            setState(() {
                              _penalty = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Ban Account permanently'),
                        leading: Radio<Penalties>(
                          value: Penalties.permanent,
                          groupValue: _penalty,
                          toggleable: true,
                          onChanged: (Penalties value) {
                            setState(() {
                              _penalty = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('Update to Reporter',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                        onChanged: (val) => setState(() => _currentReasonToR = val),
                        controller: reasonToR,
                        // Allows box to grow vertically
                        maxLines: null,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.orange, width: 1.5)))),
                  ),
                  Text('Update to Offender',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                        onChanged: (val) => setState(() => _currentReasonToO = val),
                        controller: reasonToO,
                        // Allows box to grow vertically
                        maxLines: null,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.orange, width: 1.5)))),
                  ),
                  // RadioButton(),
                  // MyTextField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32.0, top: 32.0),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            ),
                            onPressed: () async {
                              List<String> actionsTaken = new List<String>();

                              actionsTaken.add(_penalty.toString().substring(10));
                              if (_isSelected == true) {
                                actionsTaken.add("Deleted Listing");
                              }

                              String currUser = await currentUser();
                              ReportListingAction data = new ReportListingAction(
                                  reportID: widget.reportListing.reportID,
                                  actionsTaken: actionsTaken,
                                  updateToReporter: _currentReasonToR,
                                  updateToOffender: _currentReasonToO,
                                  moderatorID: currUser,
                                  actionDate: DateTime.now());

                              await ModeratorPresentor().addReportListingActionData(data);
                              await ModeratorPresentor().updateReportListingData(widget.reportListing.reportID);

                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            child: Text('Submit')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32.0, top: 32.0),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }, //show popup dialog
                            child: Text('Cancel')),
                      ),
                    ],
                  )
                ],
              ),
            )],
          ),
        ));
  }
}