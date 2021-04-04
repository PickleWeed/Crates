import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  group('Register Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    /*testWidgets('Go to RegisterNext Page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      //final emailFormField = find.byType(TextFormField).first;
      final emailFormField = find.byKey(Key('email'));
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);
    });*/
    //TODO go sign In page
    testWidgets('Go to RegisterNext Page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      //final emailFormField = find.byType(TextFormField).first;
      final emailFormField = find.byKey(Key('email'));
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);
    });
    //TODO empty value in email
    testWidgets('Create account, incorrect email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'weqawe');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      final textFinder = find.text('Invalid Email');
      expect(textFinder,findsOneWidget);
    });
    testWidgets('Go to RegisterFinal Page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.enterText(usernameFormField, 'testuser');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is RegisterFinal),findsOneWidget);
    });
    //TODO page flip
    //TODO username empty
    //TODO username less than 3
    //TODO Username is used
    //TODO Register Acc
  });
}

