import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/activity/activity.dart';
import 'package:flutter_application_1/screens/home/category_page.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/listing/Newlisting_page.dart';
import 'package:flutter_application_1/screens/nearby/nearby.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';


//Home and view listing
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

    testWidgets('Select All Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('All'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });

    testWidgets('Select Vegetables Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('Vegetable'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });

    testWidgets('Select Canned Food Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('CannedFood'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });

    // Only demo above first three
    /*testWidgets('Select Snack Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('Snacks'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });

    testWidgets('Select Beverage Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('Beverages'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    }); */

    /*
    testWidgets('Select Dairy Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('Diary'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });

    testWidgets('Select DryFood Category', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final categoryBtn = find.byKey(Key('DryFood'));
      await tester.tap(categoryBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is CategoryPage),findsOneWidget);
    });
    */

    // Select latest listing
    testWidgets('Select a latest listing', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final listingBtn = find.byKey(Key('ListingCard')).first;
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);
    });

    //TODO: BYPASS PERMISSIONS
    testWidgets('Go to Nearby', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final nearbyBtn = find.byIcon(Icons.gps_fixed);

      await tester.tap(nearbyBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Nearby),findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is GoogleMap),findsOneWidget);
    });

    // Go to new listing page
    testWidgets('Go to New listing', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListBtn = find.byIcon(Icons.add_circle_outline);
      await tester.tap(newListBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Newlisting_page ),findsOneWidget);
    });

    // This code will demo  navigation to profile page + show listing
    testWidgets('View Listing in Profile', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final profileBtn = find.byIcon(Icons.account_circle);
      await tester.tap(profileBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));
      final listingBtn = find.byKey(Key('ListingCard')).first;
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

    });

    // Navigate to Activity Page AND back to home to show home bar working
    testWidgets('Go to Activity', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final activityBtn = find.byIcon(Icons.notifications_none);
      await tester.tap(activityBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is ActivityPage ),findsOneWidget);

      final homeBtn = find.byIcon(Icons.home);
      await tester.tap(homeBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Home),findsOneWidget);
    });

    /* testWidgets('Go to Profile', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final profileBtn = find.byIcon(Icons.account_circle);
      await tester.tap(profileBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Profile),findsOneWidget);
    }); */

    //TODO Search

  });
}