import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/register.dart';
import 'package:flutter_application_1/screens/authenticate/root.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  Future<void> goToRegisterPage(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final registerBtn = find.byKey(Key('Register'));
    await tester.tap(registerBtn);

    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);
  }

  group('Register Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Go to RegisterNext Page', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      //final emailFormField = find.byType(TextFormField).first;
      final emailFormField = find.byKey(Key('email'));
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);
    });
    testWidgets('Go to SignIn Page', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final nextBtn = find.byKey(Key('SignIn'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RootPage),findsOneWidget);
    });
    testWidgets('Empty email', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, '');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      final textFinder = find.text('Email Required');
      expect(textFinder,findsOneWidget);
    });
    testWidgets('Create account, not an email', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'weqawe');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 2));
      final textFinder = find.text('Invalid Email');
      expect(textFinder,findsOneWidget);
    });
    testWidgets('Go to RegisterFinal Page', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.enterText(usernameFormField, 'testuser');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterFinal),findsOneWidget);
    });
    testWidgets('Empty username', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.enterText(usernameFormField, '');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      final textFinder = find.text('Username Required');
      expect(textFinder,findsOneWidget);
    });
    testWidgets('Empty username', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser1@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.enterText(usernameFormField, 'ee');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      final textFinder = find.text('Username must be at least 3 characters');
      expect(textFinder,findsOneWidget);
    });
    testWidgets('Create account', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser2@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.tap(usernameFormField);
      await tester.enterText(usernameFormField, 'testuser2');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterFinal),findsOneWidget);

      final passwordFormField = find.byKey(Key('password'));
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();


      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byWidgetPredicate((widget) => widget is RootPage),findsOneWidget);
    });
    testWidgets('Create account, password required', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser2@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.tap(usernameFormField);
      await tester.enterText(usernameFormField, 'testuser2');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterFinal),findsOneWidget);

      final passwordFormField = find.byKey(Key('password'));
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, '');
      await tester.pumpAndSettle();


      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 2));
      final errorTextFinder = find.text('Password Required');
      expect(errorTextFinder,findsOneWidget);
    });
    testWidgets('Create account, error password at least 6 characters', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final emailFormField = find.byType(TextFormField).first;
      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser2@gmail.com');
      await tester.pumpAndSettle();
      final nextBtn = find.byKey(Key('Next'));
      await tester.tap(nextBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterNext),findsOneWidget);

      final usernameFormField = find.byKey(Key('username'));
      await tester.tap(usernameFormField);
      await tester.enterText(usernameFormField, 'testuser2');
      await tester.pumpAndSettle();
      final next2Btn = find.byKey(Key('Next2'));
      await tester.tap(next2Btn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RegisterFinal),findsOneWidget);

      final passwordFormField = find.byKey(Key('password'));
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, '12345');
      await tester.pumpAndSettle();


      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 2));
      final errorTextFinder = find.text('Password must have at least 6 characters');
      expect(errorTextFinder,findsOneWidget);
    });
    //TODO email is already used, no feedback for me to take
    //TODO username don't allow special character or numbers
    //TODO Username is used, or allow duplicate
  });
}

