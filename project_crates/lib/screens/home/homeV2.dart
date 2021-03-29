import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/widgets.dart';
import '../common/theme.dart';
import 'homeListView.dart';
import 'listingsList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    Provider.of<HomeListViewModel>(context, listen: false).fetchListing('');
  }

  Widget _buildUI(HomeListViewModel vm) {
    if(vm.listings == null) {
      return Align(child: CircularProgressIndicator());
    } else if(vm.listings.isEmpty) {
      return Align(child: Text("No Listing found."));
    } else {
      return ListingList(listings: vm.listings);
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm=Provider.of<HomeListViewModel>(context);

    return Scaffold(
      appBar: AppBar (
        title: Text('HomePage'),
      ),
      body: _buildUI(vm)
    );
  }
}
