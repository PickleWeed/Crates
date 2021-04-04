import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/register.dart';
import 'package:flutter_application_1/screens/authenticate/root.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/screens/common/widgets.dart';

import 'package:flutter_application_1/main.dart' as app;

void main() {
  group('Login Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Login Successfully', (WidgetTester tester) async {
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
      await tester.pumpAndSettle(Duration(seconds: 5));

      final loginFinder = find.text('Login Successful');

      expect(find.byWidgetPredicate((widget) => widget is Home),findsOneWidget);
    });
    //TODO doesn't work expect, cannot get widget for wrong email/password
    testWidgets('Incorrect password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));


      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser@gmail.com');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password2');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));


      //TODO get expect
      //expect(find.byWidgetPredicate((widget) => widget is Text && widget.data.startsWith('Wrong')), findsOneWidget);
      final textFinder = find.text('Wrong Email/Password');
      /*expect(tester.getSemantics(toastMsg), matchesSemantics(
        isEnabled: true,
      ),);*/
      //expect(find.text('Wrong Email/Password'), findsOneWidget);
    });
    testWidgets('Go to Register Page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);
    });
    testWidgets('Go to Register Page, go back to Login Page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final registerBtn = find.byKey(Key('Register'));
      await tester.tap(registerBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is Register),findsOneWidget);

      final loginBtn = find.byKey(Key('SignIn'));
      await tester.tap(loginBtn);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byWidgetPredicate((widget) => widget is RootPage),findsOneWidget);
    });
    testWidgets('Email is required, Empty String', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, '');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final errorFinder = find.text('Email Required');
      expect(errorFinder, findsOneWidget);
    });
    testWidgets('Password is required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'qwef');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final errorFinder = find.text('Invalid Email');
      expect(errorFinder, findsOneWidget);
    });
    testWidgets('Password required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser@gmail.com');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, '');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final errorFinder = find.text('Password Required');
      expect(errorFinder, findsOneWidget);
    });
    testWidgets('Invalid Email, Password required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, '');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final emailErrorFinder = find.text('Invalid Email');
      final passwordErrorFinder = find.text('Password Required');
      expect(emailErrorFinder, findsOneWidget);
      expect(passwordErrorFinder, findsOneWidget);
    });
    testWidgets('Email Required, Password required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, '');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, '');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final emailErrorFinder = find.text('Email Required');
      final passwordErrorFinder = find.text('Password Required');
      expect(emailErrorFinder, findsOneWidget);
      expect(passwordErrorFinder, findsOneWidget);
    });
  });
}