import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/common/error_popup_widgets.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
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
      await tester.pumpAndSettle(Duration(seconds: 1));
      final profileBtn = find.byIcon(Icons.account_circle);

      await tester.tap(profileBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Profile),findsOneWidget);

      //Select a listing
      //TODO: Change listingID to rays one
      final listingBtn = find.byKey(Key('ListingCard')).first;
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),findsOneWidget);

      //Click Edit button
      //final editBtn = find.byKey(Key('Edit'));
      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Edit').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is Editinglist_page),findsOneWidget);
    }

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Go to Edit Listing', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
    });
    testWidgets('No Edit Just Save', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    testWidgets('Edit Request/Giving', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.pumpAndSettle(Duration(seconds: 1));
      final toggleBtn = find.byKey(Key('toggleBtn'));
      expect(tester
          .widget<ToggleButtons>(toggleBtn)
          .isSelected, [isTrue, isFalse]);


      await tester.tap(find.byKey(Key('RequestingFor')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(tester
          .widget<ToggleButtons>(toggleBtn)
          .isSelected, [isFalse, isTrue]);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    testWidgets('Edit Category', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(find.byType(DropdownButtonHideUnderline).first);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('Beverages').last);
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.text('Beverages'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    testWidgets('Edit Title', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byKey(Key('Title'));
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, 'Coffee');
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    testWidgets('Edit Description', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byKey(Key('description'));
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, 'a new null');
      await tester.pumpAndSettle();

      expect(find.text('a new null'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    //TODO Edit Location
    testWidgets('Edit location', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byType(TextField).last;
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, 'Singapore');
      await tester.pumpAndSettle();

      //TODO get out of location textField

      expect(find.text('Singapore'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    testWidgets('Edit Picture, take picture', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final imageBtn = find.byKey(Key('image'));
      await tester.tap(imageBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final cameraBtn = find.byKey(Key('Camera'));
      await tester.tap(cameraBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pumpAndSettle(Duration(seconds: 1));

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
    //TODO take a photo from photo library



    testWidgets('No Title', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byType(TextField).last;
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, '');
      await tester.pumpAndSettle();

      expect(find.text(''), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      expect(find.byKey(Key('Alert Dialog')),  findsOneWidget);
      expect(find.text('Name of product is empty.\nPlease fill up the respective field.'),  findsOneWidget);
    });
    //TODO: Check no location
     testWidgets('Edit location', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byType(TextField).last;
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, '');
      await tester.pumpAndSettle();

      //TODO get out of location textField

      expect(find.text(''), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });

    testWidgets('No Title', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byKey(Key('Title'));
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, '');
      await tester.pumpAndSettle();

      expect(find.text(''), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byKey(Key('Alert Dialog')),  findsOneWidget);
      expect(find.text('Name of product is empty.\nPlease fill up the respective field.'),  findsOneWidget);
    });
    //TODO: DO everything
    testWidgets('Edit everything', (WidgetTester tester) async {
      await loginAndProfileAndListing(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final imageBtn = find.byKey(Key('image'));
      await tester.tap(imageBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final cameraBtn = find.byKey(Key('Camera'));
      await tester.tap(cameraBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byType(DropdownButtonHideUnderline).first);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('Dry Food').last);
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.text('Dry Food'), findsOneWidget);

      final titleField = find.byKey(Key('Title'));
      await tester.tap(titleField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(titleField, 'Coffee');
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      final descriptionField = find.byKey(Key('description'));
      await tester.tap(descriptionField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(descriptionField, 'description');
      await tester.pumpAndSettle();

      expect(find.text('description'), findsOneWidget);

      /*final locationTextField = find.byType(TextField).last;
      await tester.tap(locationTextField);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(locationTextField, 'Singapore');
      await tester.pumpAndSettle(); */

      //TODO get out of location textField

      await tester.pump(const Duration(milliseconds: 100));
      ElevatedButton button = find.widgetWithText(ElevatedButton, 'Save Changes').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is UserMain),findsOneWidget);
    });
  });
}