// Dummy page to test database functionalities
// To view this dummy page, replace the 'home' property value in main.dart to CreateListingTest()

import 'package:flutter/material.dart';
import 'package:flutter_application_1/databaseAccess.dart';

class CreateListingTest extends StatefulWidget {
  @override
  _CreateListingTestState createState() => _CreateListingTestState();
}

class _CreateListingTestState extends State<CreateListingTest> {
  DatabaseAccess dao = new DatabaseAccess();
  List<bool> isSelected = [true, false];
  String _selectedCategory;
  List<String> _categories = ['Canned Food', 'Vegetables', 'Raw Meat'];
  final itemNameController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Listing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.grey,
              borderWidth: 2,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Requesting for',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Giving away',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
              isSelected: isSelected,
            ),
            DropdownButton(
              hint: Text('Select category'),
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name',
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
                child: Text("Create listing"),
                onPressed: () {
                  //using 'testuser' for userID cos I'm unable to login
                  dao.addListing(isSelected[0], _selectedCategory,
                      itemNameController.text, descController.text, 'testuser');
                }),
          ],
        ),
      ),
    );
  }
}
