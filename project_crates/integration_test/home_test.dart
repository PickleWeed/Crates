import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/nearby/nearby.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_driver/flutter_driver.dart' as fluttering;
import 'package:path/path.dart';


void main() {
  /*fluttering.FlutterDriver tester;
  setUpAll(() async {
    final Map<String, String> envVars = Platform.environment;
    final String adbPath = envVars['ANDROID_SDK_ROOT'] + '/platform-tools/adb.exe';
    await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.apppackage', 'android.permission.ACCESS_FINE_LOCATION']);
    await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.apppackage',  'android.permission.ACCESS_COARSE_LOCATION']);
  tester = await fluttering.FlutterDriver.connect();
  });
  Future<bool> isPresent(fluttering.SerializableFinder byValueKey,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      await tester.waitFor(byValueKey, timeout: timeout);
      return true;
    } catch (exception) {
      return false;
    }
  }
  tearDownAll(() async {
    if (tester != null) {
      await tester.close();
    }
  });*/


  Future<void> login(WidgetTester tester) async {
    app.main();
    //sign_in.SignIn();
    await tester.pumpAndSettle();
    final emailFormField = find.byKey(Key('email'));
    final passwordFormField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('Login'));


    await tester.tap(emailFormField);
    await tester.enterText(emailFormField, 'testuser@gmail.com');
    await tester.tap(passwordFormField);
    await tester.enterText(passwordFormField, 'password');
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    await tester.pumpAndSettle(Duration(seconds: 3));


    expect(find.byWidgetPredicate((widget) => widget is Home),findsOneWidget);
  }

  group('HomePage', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //TODO Select a listing in latest
    testWidgets('Select a listing', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final listingBtn = find.byKey(Key('listingIDWidget:-MXLWXGqn-3lzi3Ej_Qx'));
      await tester.tap(listingBtn);

      //TODO expect
    });
    //TODO Select All
    //TODO Select Veg
    //TODO select a listing
    //TODO Select Canned Food
    //TODO Select Snack
    //TODO Select Beverage
    //TODO Select Dairy Products
    //TODO Select Dry Food

    //TODO Select navigationBar Home
    //TODO Select navigationBar Nearby
    /*testWidgets('Go to Nearby', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final nearbyBtn = find.byIcon(Icons.gps_fixed);

      await tester.tap(nearbyBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Nearby),findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is GoogleMap),findsOneWidget);
    });*/
    //TODO Select navigationBar New Listing
    //TODO Select navigationBar Activity
    //TODO Select navigationBar Profile

    //TODO Search
  });
}