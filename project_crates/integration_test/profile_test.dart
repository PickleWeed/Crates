import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;

void main() {
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

  }
  // This code will demo  navigation to profile page + show listing
  testWidgets('View Profile', (WidgetTester tester) async {
    await login(tester);
    await tester.pumpAndSettle(Duration(seconds: 3));
    final profileBtn = find.byIcon(Icons.account_circle);
    await tester.tap(profileBtn);
    await tester.pumpAndSettle(Duration(seconds: 3));

  });

  // This code will demo  navigation to profile page + show listing
  testWidgets('View Listing in Profile', (WidgetTester tester) async {
  await login(tester);
  await tester.pumpAndSettle(Duration(seconds: 3));
  final profileBtn = find.byIcon(Icons.account_circle);
  await tester.tap(profileBtn);
  await tester.pumpAndSettle(Duration(seconds: 3));
  final listingBtn = find.byKey(Key('ListingCard')).first;
  await tester.tap(listingBtn);
  await tester.pumpAndSettle(Duration(seconds: 2));

  });

  }