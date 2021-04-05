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
    });*/
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
      await tester.tap(createListingBtn);
      await tester.tap(createListingBtn);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 1));
      //expect(find.byWidgetPredicate((widget) => widget is Dialogs),findsOneWidget);
      //expect(find.byType(Dialogs), findsNothing);
    });
  });
}