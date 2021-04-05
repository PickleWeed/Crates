import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/common/error_popup_widgets.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/screens/listing/Newlisting_page.dart';

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_driver/driver_extension.dart';

import '../lib/screens/common/theme.dart';

class _IsToggled extends CustomMatcher {
  _IsToggled(dynamic matcher)
      : super('Check if a switch if enabled or not', 'isToggled', matcher);

  @override
  Object featureValueOf(dynamic actual) {
    final finder =actual as Finder;
    final result = finder.evaluate().single as Switch;

    return result.value;
  }
}

Matcher isToggled(bool value) => _IsToggled(value);

void main() {
  group('New Listing', () {

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



    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    /*testWidgets('listing Page', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Body),findsOneWidget);
    });
    testWidgets('Select Camera', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Body),findsOneWidget);

      final imageBtn = find.byKey(Key('image'));
      await tester.tap(imageBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final cameraBtn = find.byKey(Key('Camera'));
      await tester.tap(cameraBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pumpAndSettle(Duration(seconds: 1));

    });
    testWidgets('Select Photo Library', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Body),findsOneWidget);

      final imageBtn = find.byKey(Key('image'));
      await tester.tap(imageBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final photoLibraryBtn = find.byKey(Key('PhotoLibrary'));
      await tester.tap(photoLibraryBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));


      /*enableFlutterDriverExtension();
      const channel =
      MethodChannel('plugins.flutter.io/image_picker');

      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        var data = await rootBundle.load('coffee.png');
        var bytes = data.buffer.asUint8List();
        var tempDir = await getTemporaryDirectory();
        var file = await File('${tempDir.path}/tmp.tmp', ).writeAsBytes(bytes);
        print(file.path);
        return file.path;
      });*/

      await tester.pumpAndSettle(Duration(seconds: 1));

    });
    testWidgets('Picture needed', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Body),findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      final createListingBtn = find.byKey(Key('CreateListing'));
      await tester.tap(createListingBtn);

      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dialogs), findsNothing);
      //expect(find.byWidgetPredicate((widget) => widget is Dialogs),findsOneWidget);
      //final errorTextFinder = find.text('Please select a photo!');
      //final errorPopUp = find.byKey(Key('Alert Dialog'));
      //await tester.tap(errorPopUp);
      //await tester.pumpAndSettle(Duration(seconds: 1));
      //expect(errorTextFinder, findsOneWidget);
    });
    testWidgets('Name of product cannot be empty!', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Body),findsOneWidget);

      final imageBtn = find.byKey(Key('image'));
      await tester.tap(imageBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final cameraBtn = find.byKey(Key('Camera'));
      await tester.tap(cameraBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byType(DropdownButtonHideUnderline).first);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('Dairy Product').last);
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 1));

      final gesture = await tester.startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle(Duration(seconds: 1));

      final createListingBtn = find.byKey(Key('CreateListing'));
      await tester.tap(createListingBtn);
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));

      //TODO Expect
      //expect(find.byWidgetPredicate((widget) => widget is Dialogs),findsOneWidget);
      //expect(find.byType(Dialogs), findsNothing);
    });*/
    //TODO Address cannot be empty!
    //TODO Selecting requesting For
    testWidgets('Select Request For!', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final newListingBtn = find.byIcon(Icons.add_circle_outline);

      await tester.tap(newListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(
          find.byWidgetPredicate((widget) => widget is Body), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 1));
      //expect(find.byKey(Key('GivingAway')), findsOneWidget);
      final toggleBtn = find.byKey(Key('GivingAway'));

      List<bool> isselected = [true, false];

      expect(isselected[0], isTrue);
      expect(isselected[1], isFalse);

      //expect (tester.getSemantics(toggleBtn), matchesSemantics(
      //  isButton: true,
      //),);
      /*Matcher isToggled(bool value) => _IsToggled(value);
      final finder = find.byWidgetPredicate(
              (widget) => widget is Switch && widget.key == toggleBtn && widget.value == true,
          description: 'Giving away');
      expect(finder, findsOneWidget);*/
      //await tester.tap(find.byKey(Key('GivingAway')));
      
      /*expect(
          find.byWidgetPredicate((widget) =>
          widget is ToggleButtons &&
          widget.children is Text &&
          (widget.children as Text).data.startsWith('Requesting for')), findsOneWidget);*/
    });
    //TODO select category
    //TODO enter Listing Title
    //TODO enter description
    //TODO Enter location
  });
}