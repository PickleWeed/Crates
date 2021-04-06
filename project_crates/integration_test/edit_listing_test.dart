import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/listing/Editinglist_page.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/screens/profile/profile.dart' as profile;

void main() {

  group('Edit Listing', () {
    Future<void> loginAndProfileAndListing(WidgetTester tester) async {
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

      // Go to Profile Page
      await tester.pumpAndSettle(Duration(seconds: 3));
      final profileBtn = find.byIcon(Icons.account_circle);

      await tester.tap(profileBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byWidgetPredicate((widget) => widget is Profile),findsOneWidget);

      //Select a listing
      //TODO: Change listingID to rays one
      final listingBtn = find.byKey(Key('listingIDWidget:-MWgwTUIGOENUbfuziaF'));
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      //Click Edit button
      final editBtn = find.byKey(Key('Edit'));
      await tester.tap(editBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    }

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    //TODO: Edit Image
    /* testWidgets('Edit Image', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final listingBtn = find.byKey(Key('listingIDWidget:-MWgwTUIGOENUbfuziaF'));
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      final editBtn = find.byKey(Key('Edit'));
      await tester.tap(editBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);

      // Edit image - coffee
      final saveBtn = find.byKey(Key('Save'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      final saveBtn = find.byKey(Key('Save'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

     // expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    }); */

    testWidgets('Edit Request/Giving', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final listingBtn = find.byKey(Key('listingIDWidget:-MWgwTUIGOENUbfuziaF'));
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      final editBtn = find.byKey(Key('Edit'));
      await tester.tap(editBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);

      //final toggleBtn = find.byKey(Key('RequestingFor'));
      //final toggleBtn = find.byKey(Key('RequestingFor'));
      // expect(tester.widget<ToggleButtons>(toggleBtn).isSelected, isFalse);

      final saveBtn = find.byKey(Key('Save'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    });

    testWidgets('Edit Category', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final listingBtn = find.byKey(Key('listingIDWidget:-MWgwTUIGOENUbfuziaF'));
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      final editBtn = find.byKey(Key('Edit'));
      await tester.tap(editBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);

      await tester.tap(find.byType(DropdownButtonHideUnderline).first);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('Beverages'));
      await tester.pumpAndSettle(Duration(seconds: 1));

      final saveBtn = find.byKey(Key('Save'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      // expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    });

    //TODO: Edit food name
    testWidgets('Edit Title', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final listingBtn = find.byKey(Key('listingIDWidget:-MWgwTUIGOENUbfuziaF'));
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      final editBtn = find.byKey(Key('Edit'));
      await tester.tap(editBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);

      final titleField = find.byKey(Key('Title'));
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(titleField, 'Coffee');
      await tester.pumpAndSettle();

      final saveBtn = find.byKey(Key('Save'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      // expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    });
    //TODO: Edit description
    //TODO: Edit location
    //TODO: Check Empty Validation
  });
}