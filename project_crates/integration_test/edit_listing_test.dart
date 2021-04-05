import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/screens/profile/profile.dart' as profile;

void main() {
  group('Edit Listing', () {
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
    //TODO: Click on Profile tab
    testWidgets('Go to Profile Page', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      final profileBtn = find.byIcon(Icons.account_circle);

      await tester.tap(profileBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byWidgetPredicate((widget) => widget is Profile),findsOneWidget);
    });
    //TODO: Profile tab click on a listing
    //TODO: Click on edit listing button
    //TODO: Edit image
    //TODO: Edit Request/giving
    //TODO: Edit food category
    //TODO: Edit food name
    //TODO: Edit description
    //TODO: Edit location

  });
}